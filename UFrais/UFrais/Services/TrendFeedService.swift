import Foundation
import Combine

/// Charge les produits en vogue du jour (web / réseaux), sans chiffres magasin.
@MainActor
final class TrendFeedService: ObservableObject {
    @Published var items: [TrendingProduct] = []
    @Published var headline = "Tendances frais"
    @Published var sourceNote = ""
    @Published var updatedAt: Date?
    @Published var isLoading = false
    @Published var lastError: String?
    @Published var feedOrigin = "Cache local"

    /// JSON hébergé sur le dépôt — mis à jour côté web sans republier l'app.
    /// Branche images prioritaire tant que le correctif fruits rouges n'est pas sur main.
    static let remoteCandidates: [URL] = [
        "https://raw.githubusercontent.com/BabaLeparoux49/Dev-01/cursor/tendances-images-nouveautes-2bfd/UFrais/UFrais/Data/trends.json",
        "https://raw.githubusercontent.com/BabaLeparoux49/Dev-01/main/UFrais/UFrais/Data/trends.json",
        "https://raw.githubusercontent.com/BabaLeparoux49/Dev-01/cursor/ufrais-super-u-ligne-2bfd/UFrais/UFrais/Data/trends.json"
    ].compactMap(URL.init(string:))

    /// Flux presse food (signaux complémentaires).
    private let rssFeeds: [URL] = [
        URL(string: "https://www.lineaires.com/rss.xml"),
        URL(string: "https://www.lsa-conso.fr/rss")
    ].compactMap { $0 }

    private let cacheKey = "ufrais.trends.cache.v3"
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        e.outputFormatting = [.prettyPrinted, .sortedKeys]
        return e
    }()

    init() {
        if let cached = loadCache() {
            apply(cached, origin: "Dernière synchro")
        } else if let bundled = loadBundled() {
            apply(bundled, origin: "Packagé dans l'app")
        }
        Task { await refresh() }
    }

    var topItems: [TrendingProduct] {
        items.sorted { $0.buzzScore > $1.buzzScore }
    }

    func items(in rayon: RayonKind?, category: TrendCategory? = nil) -> [TrendingProduct] {
        var base = topItems
        if let category {
            base = base.filter { $0.resolvedCategory == category }
        }
        guard let rayon else { return base }
        return base.filter { $0.rayon == rayon }
    }

    func refresh() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }

        do {
            let data = try await Self.fetchRemoteTrends()
            let payload = try decoder.decode(TrendsPayload.self, from: data)
            apply(payload, origin: "Web · tendances du jour")
            saveCache(payload)
            await enrichProductImages()
            await enrichWithRSSHints()
        } catch {
            if items.isEmpty, let bundled = loadBundled() {
                apply(bundled, origin: "Hors-ligne · packagé")
            }
            lastError = "Mise à jour web indisponible — affichage du dernier jeu connu."
            await enrichProductImages()
            await enrichWithRSSHints()
        }
    }

    private static func fetchRemoteTrends() async throws -> Data {
        var lastError: Error = URLError(.badURL)
        for url in remoteCandidates {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                    lastError = URLError(.badServerResponse)
                    continue
                }
                return data
            } catch {
                lastError = error
            }
        }
        throw lastError
    }

    // MARK: - Private

    private func apply(_ payload: TrendsPayload, origin: String) {
        items = payload.items
        headline = payload.headline
        sourceNote = payload.sourceNote
        updatedAt = payload.updatedAt
        feedOrigin = origin
    }

    private func loadBundled() -> TrendsPayload? {
        guard let url = Bundle.main.url(forResource: "trends", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return try? decoder.decode(TrendsPayload.self, from: data)
    }

    private func loadCache() -> TrendsPayload? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else { return nil }
        return try? decoder.decode(TrendsPayload.self, from: data)
    }

    private func saveCache(_ payload: TrendsPayload) {
        if let data = try? encoder.encode(payload) {
            UserDefaults.standard.set(data, forKey: cacheKey)
        }
    }

    /// Complète les images manquantes via Open Food Facts (barcode).
    private func enrichProductImages() async {
        var changed = false
        for index in items.indices {
            let item = items[index]
            guard let barcode = item.barcode, !barcode.isEmpty else { continue }
            guard item.imageURL == nil || item.imageURL?.isEmpty == true else { continue }
            guard let product = try? await OpenFoodFactsClient.lookup(barcode: barcode),
                  let url = product.imageURL else { continue }
            items[index].imageURL = url.absoluteString
            changed = true
        }
        if changed {
            let payload = TrendsPayload(
                updatedAt: updatedAt ?? Date(),
                headline: headline,
                sourceNote: sourceNote,
                items: items
            )
            saveCache(payload)
        }
    }

    /// Ajoute des tags « presse » si des flux RSS répondent (best-effort, non bloquant).
    private func enrichWithRSSHints() async {
        for feedURL in rssFeeds.prefix(2) {
            guard let (data, _) = try? await URLSession.shared.data(from: feedURL),
                  let xml = String(data: data, encoding: .utf8) else { continue }
            let titles = Self.extractRSSTitles(from: xml)
            let keywords = ["frais", "fruit", "légume", "boucher", "poisson", "fromage", "traiteur", "viral", "tiktok", "tendance"]
            let hits = titles.filter { title in
                keywords.contains { title.localizedCaseInsensitiveContains($0) }
            }
            if !hits.isEmpty {
                sourceNote = (sourceNote.isEmpty ? "" : sourceNote + " ")
                    + "Signaux presse du jour : \(hits.prefix(2).joined(separator: " · "))."
                feedOrigin = feedOrigin.contains("presse") ? feedOrigin : feedOrigin + " + presse"
                break
            }
        }
    }

    private static func extractRSSTitles(from xml: String) -> [String] {
        var titles: [String] = []
        var search = xml[...]
        while let start = search.range(of: "<title>"),
              let end = search[start.upperBound...].range(of: "</title>") {
            let raw = String(search[start.upperBound..<end.lowerBound])
                .replacingOccurrences(of: "<![CDATA[", with: "")
                .replacingOccurrences(of: "]]>", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if !raw.isEmpty { titles.append(raw) }
            search = search[end.upperBound...]
            if titles.count > 12 { break }
        }
        return Array(titles.dropFirst()) // skip channel title
    }
}
