import Foundation

struct ScannedProduct: Equatable {
    var barcode: String
    var name: String
    var brand: String?
    var quantity: String?
    var imageURL: URL?
    var categories: String?

    var displayName: String {
        if let brand, !brand.isEmpty {
            return "\(name) — \(brand)"
        }
        return name
    }
}

enum OpenFoodFactsError: LocalizedError {
    case invalidBarcode
    case notFound
    case network(String)

    var errorDescription: String? {
        switch self {
        case .invalidBarcode: return "Code-barres invalide."
        case .notFound: return "Produit introuvable dans Open Food Facts."
        case .network(let message): return message
        }
    }
}

enum OpenFoodFactsClient {
    /// Lookup produit par EAN/UPC (API publique Open Food Facts).
    static func lookup(barcode: String) async throws -> ScannedProduct {
        let cleaned = barcode.filter(\.isNumber)
        guard cleaned.count >= 8 else { throw OpenFoodFactsError.invalidBarcode }

        var request = URLRequest(
            url: URL(string: "https://world.openfoodfacts.org/api/v2/product/\(cleaned).json")!
        )
        request.setValue("UFrais/1.0 (Super U Ligné — adjoint frais)", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 12

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw OpenFoodFactsError.network(error.localizedDescription)
        }

        guard let http = response as? HTTPURLResponse else {
            throw OpenFoodFactsError.network("Réponse invalide")
        }
        guard (200...299).contains(http.statusCode) else {
            throw OpenFoodFactsError.network("HTTP \(http.statusCode)")
        }

        let decoded = try JSONDecoder().decode(OFFResponse.self, from: data)
        guard decoded.status == 1, let product = decoded.product else {
            throw OpenFoodFactsError.notFound
        }

        let name = product.productNameFr?.nilIfEmpty
            ?? product.productName?.nilIfEmpty
            ?? "Produit \(cleaned)"

        let image = product.imageFrontURL?.nilIfEmpty
            ?? product.imageFrontSmallURL?.nilIfEmpty

        return ScannedProduct(
            barcode: cleaned,
            name: name,
            brand: product.brands?.nilIfEmpty,
            quantity: product.quantity?.nilIfEmpty,
            imageURL: image.flatMap(URL.init(string:)),
            categories: product.categories?.nilIfEmpty
        )
    }

    private struct OFFResponse: Decodable {
        var status: Int
        var product: OFFProduct?
    }

    private struct OFFProduct: Decodable {
        var productName: String?
        var productNameFr: String?
        var brands: String?
        var quantity: String?
        var imageFrontURL: String?
        var imageFrontSmallURL: String?
        var categories: String?

        enum CodingKeys: String, CodingKey {
            case productName = "product_name"
            case productNameFr = "product_name_fr"
            case brands, quantity, categories
            case imageFrontURL = "image_front_url"
            case imageFrontSmallURL = "image_front_small_url"
        }
    }
}

private extension String {
    var nilIfEmpty: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}

struct CompetitorGap: Equatable {
    var myPriceTTC: Double
    var competitorPriceTTC: Double

    var difference: Double { myPriceTTC - competitorPriceTTC }
    var absDifference: Double { abs(difference) }
    var percentVsCompetitor: Double {
        guard competitorPriceTTC > 0 else { return 0 }
        return difference / competitorPriceTTC
    }

    var verdict: String {
        if abs(difference) < 0.005 { return "Prix aligné" }
        if difference > 0 { return "Tu es plus cher" }
        return "Tu es moins cher"
    }

    var isAligned: Bool { abs(difference) < 0.005 }
    var iAmMoreExpensive: Bool { difference > 0.005 }
}
