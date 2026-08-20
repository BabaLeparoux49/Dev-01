import SwiftUI

enum RayonKind: String, CaseIterable, Identifiable, Codable, Hashable {
    case fruitsLegumes
    case boucherie
    case poissonnerie
    case charcuterie
    case cremerie
    case traiteur
    case boulangerie

    var id: String { rawValue }

    var title: String {
        switch self {
        case .fruitsLegumes: return "Fruits & Légumes"
        case .boucherie: return "Boucherie"
        case .poissonnerie: return "Poissonnerie"
        case .charcuterie: return "Charcuterie"
        case .cremerie: return "Crèmerie"
        case .traiteur: return "Traiteur"
        case .boulangerie: return "Boulangerie"
        }
    }

    var symbol: String {
        switch self {
        case .fruitsLegumes: return "leaf.fill"
        case .boucherie: return "fork.knife"
        case .poissonnerie: return "fish.fill"
        case .charcuterie: return "fork.knife.circle.fill"
        case .cremerie: return "cup.and.saucer.fill"
        case .traiteur: return "takeoutbag.and.cup.and.straw.fill"
        case .boulangerie: return "oven.fill"
        }
    }

    var defaultVAT: VATRate {
        switch self {
        case .traiteur: return .intermediaire
        default: return .alimentaire
        }
    }

    var tint: Color {
        switch self {
        case .fruitsLegumes: return UColor.vertEau
        case .boucherie: return UColor.rouge
        case .poissonnerie: return UColor.bleuSignature
        case .charcuterie: return Color(red: 0.76, green: 0.33, blue: 0.28)
        case .cremerie: return UColor.bleuCiel
        case .traiteur: return Color(red: 0.93, green: 0.55, blue: 0.18)
        case .boulangerie: return Color(red: 0.85, green: 0.62, blue: 0.28)
        }
    }
}

struct FreshProduct: Identifiable, Hashable {
    let id: UUID
    var name: String
    var brand: String
    var origin: String
    var rayon: RayonKind
    var paHT: Double
    var pvTTC: Double
    var vat: VATRate
    var stock: Int
    var facing: Int
    var unitsSoldToday: Int
    var dlcHours: Int?
    var isPromo: Bool
    var unit: String
    var vaTrend: [Double]

    var breakdown: MarginBreakdown {
        MarginBreakdown(paHT: paHT, pvTTC: pvTTC, vat: vat)
    }

    var contributionToday: Double {
        breakdown.grossMargin * Double(unitsSoldToday)
    }

    var stockAlert: Bool { stock <= 4 }
    var dlcAlert: Bool {
        guard let dlcHours else { return false }
        return dlcHours <= 18
    }

    var opportunityScore: Double {
        breakdown.marqueRate * 0.45
            + min(contributionToday / 80, 1) * 0.35
            + (isPromo ? 0.08 : 0)
            + (stockAlert ? 0.12 : 0)
    }
}

struct LiveEvent: Identifiable, Equatable {
    enum Kind: String {
        case sale, alert, opportunity, dlc
    }

    let id: UUID
    let date: Date
    let kind: Kind
    let title: String
    let detail: String
    let rayon: RayonKind

    var tint: Color {
        switch kind {
        case .sale: return UColor.vertEau
        case .alert: return UColor.rouge
        case .opportunity: return UColor.bleuSignature
        case .dlc: return Color.orange
        }
    }

    var symbol: String {
        switch kind {
        case .sale: return "cart.fill"
        case .alert: return "exclamationmark.triangle.fill"
        case .opportunity: return "sparkles"
        case .dlc: return "clock.badge.exclamationmark.fill"
        }
    }
}

struct RayonSnapshot: Identifiable {
    var kind: RayonKind
    var caTTC: Double
    var marge: Double
    var marque: Double
    var ruptures: Int
    var dlc: Int

    var id: RayonKind { kind }
}
