import Foundation
import Combine

@MainActor
final class LiveFeedService: ObservableObject {
    @Published var products: [FreshProduct]
    @Published var events: [LiveEvent] = []
    @Published var lastUpdate: Date = .now
    @Published var isLive = true
    @Published var tickCount = 0

    private var loop: Task<Void, Never>?

    init(catalog: [FreshProduct] = SampleCatalog.products) {
        products = catalog
        events = [
            LiveEvent(
                id: UUID(),
                date: .now.addingTimeInterval(-40),
                kind: .opportunity,
                title: "Comté 18 mois — marque 41,2 %",
                detail: "Valeur ajoutée parmi les plus hautes du rayon crèmerie. 8 kg encore en réserve.",
                rayon: .cremerie
            ),
            LiveEvent(
                id: UUID(),
                date: .now.addingTimeInterval(-95),
                kind: .dlc,
                title: "Pain au chocolat — DLC courte",
                detail: "Fournée du matin. Prioriser la mise en avant avant 11 h.",
                rayon: .boulangerie
            )
        ]
        start()
    }

    func start() {
        loop?.cancel()
        isLive = true
        loop = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(2400))
                guard let self else { break }
                guard self.isLive else { continue }
                self.tick()
            }
        }
    }

    func pause() {
        isLive = false
        loop?.cancel()
        loop = nil
    }

    func toggle() {
        if isLive {
            pause()
        } else {
            start()
        }
    }

    var caJour: Double {
        products.reduce(0) { $0 + $1.pvTTC * Double($1.unitsSoldToday) }
    }

    var margeJour: Double {
        products.reduce(0) { $0 + $1.contributionToday }
    }

    var marqueMoyenne: Double {
        let active = products.filter { $0.unitsSoldToday > 0 }
        guard !active.isEmpty else { return 0 }
        let weighted = active.reduce(0) { $0 + $1.breakdown.marqueRate * $1.contributionToday }
        let total = active.reduce(0) { $0 + $1.contributionToday }
        return total == 0 ? 0 : weighted / total
    }

    var alertCount: Int {
        products.filter { $0.stockAlert || $0.dlcAlert }.count
    }

    var topVA: [FreshProduct] {
        products.sorted { $0.contributionToday > $1.contributionToday }
    }

    var topMarque: [FreshProduct] {
        products.sorted { $0.breakdown.marqueRate > $1.breakdown.marqueRate }
    }

    var opportunities: [FreshProduct] {
        products.sorted { $0.opportunityScore > $1.opportunityScore }
    }

    func snapshots() -> [RayonSnapshot] {
        RayonKind.allCases.map { kind in
            let items = products.filter { $0.rayon == kind }
            let ca = items.reduce(0) { $0 + $1.pvTTC * Double($1.unitsSoldToday) }
            let marge = items.reduce(0) { $0 + $1.contributionToday }
            let pvHT = items.reduce(0) { $0 + $1.breakdown.pvHT * Double($1.unitsSoldToday) }
            return RayonSnapshot(
                kind: kind,
                caTTC: ca,
                marge: marge,
                marque: pvHT == 0 ? 0 : marge / pvHT,
                ruptures: items.filter(\.stockAlert).count,
                dlc: items.filter(\.dlcAlert).count
            )
        }
    }

    func products(in rayon: RayonKind) -> [FreshProduct] {
        products.filter { $0.rayon == rayon }
            .sorted { $0.contributionToday > $1.contributionToday }
    }

    private func tick() {
        guard !products.isEmpty else { return }
        tickCount += 1
        lastUpdate = .now

        let sales = Int.random(in: 1...3)
        for _ in 0..<sales {
            guard let index = weightedSaleIndex() else { continue }
            var product = products[index]
            let qty = product.rayon == .boulangerie ? Int.random(in: 1...4) : 1
            product.unitsSoldToday += qty
            product.stock = max(0, product.stock - qty)
            var trend = product.vaTrend
            trend.append(Double(product.unitsSoldToday))
            if trend.count > 8 { trend.removeFirst(trend.count - 8) }
            product.vaTrend = trend
            products[index] = product

            let gain = product.breakdown.grossMargin * Double(qty)
            push(
                LiveEvent(
                    id: UUID(),
                    date: .now,
                    kind: .sale,
                    title: "\(product.name) · +\(qty) \(product.unit)",
                    detail: "Marge générée \(gain.euros) · stock restant \(product.stock)",
                    rayon: product.rayon
                )
            )

            if product.stockAlert {
                push(
                    LiveEvent(
                        id: UUID(),
                        date: .now,
                        kind: .alert,
                        title: "Stock tendu — \(product.name)",
                        detail: "Plus que \(product.stock) \(product.unit). Réassort rayon \(product.rayon.title).",
                        rayon: product.rayon
                    )
                )
            }
        }

        if tickCount.isMultiple(of: 4), let agingIndex = products.indices.randomElement() {
            if var hours = products[agingIndex].dlcHours, hours > 0 {
                hours = max(0, hours - Int.random(in: 1...3))
                products[agingIndex].dlcHours = hours
                if hours <= 8 {
                    let product = products[agingIndex]
                    push(
                        LiveEvent(
                            id: UUID(),
                            date: .now,
                            kind: .dlc,
                            title: "DLC courte — \(product.name)",
                            detail: "Environ \(hours) h restantes. Envisager démarque ou mise en avant.",
                            rayon: product.rayon
                        )
                    )
                }
            }
        }

        if tickCount.isMultiple(of: 5), let best = topMarque.first {
            push(
                LiveEvent(
                    id: UUID(),
                    date: .now,
                    kind: .opportunity,
                    title: "Forte VA — \(best.name)",
                    detail: "Marque \(best.breakdown.marqueRate.percentFR) · contribution du jour \(best.contributionToday.euros)",
                    rayon: best.rayon
                )
            )
        }
    }

    private func weightedSaleIndex() -> Int? {
        let weights = products.map { max(1, $0.facing + $0.unitsSoldToday / 4) }
        let total = weights.reduce(0, +)
        guard total > 0 else { return products.indices.randomElement() }
        var pick = Int.random(in: 0..<total)
        for (index, weight) in weights.enumerated() {
            if pick < weight { return index }
            pick -= weight
        }
        return products.indices.last
    }

    private func push(_ event: LiveEvent) {
        events.insert(event, at: 0)
        if events.count > 24 {
            events = Array(events.prefix(24))
        }
    }
}
