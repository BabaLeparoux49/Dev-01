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

enum TrendHeat: String, Codable, CaseIterable {
    case viral, hot, rising, steady

    var label: String {
        switch self {
        case .viral: return "Viral"
        case .hot: return "En vogue"
        case .rising: return "En hausse"
        case .steady: return "Stable"
        }
    }

    var tint: Color {
        switch self {
        case .viral: return UColor.rouge
        case .hot: return Color.orange
        case .rising: return UColor.bleuSignature
        case .steady: return UColor.vertEau
        }
    }
}

/// Filtre principal Tendances : buzz web vs nouveautés marques nationales.
enum TrendCategory: String, Codable, CaseIterable, Identifiable, Hashable {
    case vogue
    case nouveaute

    var id: String { rawValue }

    var title: String {
        switch self {
        case .vogue: return "En vogue"
        case .nouveaute: return "Nouveautés"
        }
    }

    var symbol: String {
        switch self {
        case .vogue: return "flame.fill"
        case .nouveaute: return "sparkles"
        }
    }
}

struct TrendSource: Identifiable, Codable, Hashable {
    var id: String { url }
    var title: String
    var url: String
}

struct TrendingProduct: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var subtitle: String
    var rayon: RayonKind
    var buzzScore: Int
    var heat: TrendHeat
    var platforms: [String]
    var why: String
    var rayonTip: String
    var sources: [TrendSource]
    var tags: [String]
    /// `vogue` (défaut) ou `nouveaute` — marques nationales / sorties rayon.
    var category: TrendCategory?
    /// URL image produit (Open Food Facts ou CDN).
    var imageURL: String?
    /// EAN pour résoudre / rafraîchir l'image via Open Food Facts.
    var barcode: String?

    var resolvedCategory: TrendCategory { category ?? .vogue }

    var resolvedImageURL: URL? {
        imageURL.flatMap(URL.init(string:))
    }
}

struct TrendsPayload: Codable {
    var updatedAt: Date
    var headline: String
    var sourceNote: String
    var items: [TrendingProduct]
}

struct StoreIdentity {
    static let name = "Super U Ligné"
    static let city = "Ligné"
    static let postalCode = "44850"
    static let address = "89 rue du Souvenir"
    static let department = "Loire-Atlantique"
    static let role = "Adjoint de direction · Produits frais"
    static let userFirstName = "Bastien"
}
