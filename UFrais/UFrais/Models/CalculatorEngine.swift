import Foundation

/// Moteur de calcul magasin (produits frais, France).
///
/// - Taux de **marge** = (PV HT − PA HT) / PA HT
/// - Taux de **marque** = (PV HT − PA HT) / PV HT  ← indicateur de référence en GMS
/// - Coefficient = PV HT / PA HT
/// - TVA alimentaire courante : 5,5 % (10 % traiteur, 20 % standard, 2,1 % super-réduit)
enum VATRate: Double, CaseIterable, Identifiable, Codable {
    case superReduit = 0.021
    case alimentaire = 0.055
    case intermediaire = 0.10
    case normal = 0.20

    var id: Double { rawValue }

    var label: String {
        switch self {
        case .superReduit: return "2,1 %"
        case .alimentaire: return "5,5 %"
        case .intermediaire: return "10 %"
        case .normal: return "20 %"
        }
    }

    var caption: String {
        switch self {
        case .superReduit: return "Super-réduit"
        case .alimentaire: return "Alimentaire"
        case .intermediaire: return "Traiteur / restauration"
        case .normal: return "Taux normal"
        }
    }
}

struct MarginBreakdown: Equatable {
    var paHT: Double
    var pvTTC: Double
    var vat: VATRate

    var pvHT: Double { pvTTC / (1 + vat.rawValue) }
    var paTTC: Double { paHT * (1 + vat.rawValue) }
    var grossMargin: Double { pvHT - paHT }
    var marginRate: Double { paHT == 0 ? 0 : grossMargin / paHT }
    var marqueRate: Double { pvHT == 0 ? 0 : grossMargin / pvHT }
    var coefficient: Double { paHT == 0 ? 0 : pvHT / paHT }
    var vatCollected: Double { pvHT * vat.rawValue }
    var vatDeductible: Double { paHT * vat.rawValue }
    var vatNet: Double { vatCollected - vatDeductible }
    var ttcMargin: Double { pvTTC - paTTC }

    var isValid: Bool { paHT > 0 && pvTTC > 0 }
    var isLoss: Bool { grossMargin < 0 }
}

enum CalculatorEngine {
    /// Prix de vente TTC pour atteindre un taux de marque cible.
    static func sellingPriceTTC(paHT: Double, targetMarque: Double, vat: VATRate) -> Double {
        guard paHT > 0, targetMarque < 1 else { return 0 }
        let pvHT = paHT / (1 - targetMarque)
        return pvHT * (1 + vat.rawValue)
    }

    static func ht(fromTTC ttc: Double, vat: VATRate) -> Double {
        ttc / (1 + vat.rawValue)
    }

    static func ttc(fromHT ht: Double, vat: VATRate) -> Double {
        ht * (1 + vat.rawValue)
    }

    static func vatAmount(ht: Double, vat: VATRate) -> Double {
        ht * vat.rawValue
    }
}

struct SavedCalculation: Identifiable, Codable, Equatable {
    var id: UUID
    var createdAt: Date
    var productName: String
    var paHT: Double
    var pvTTC: Double
    var vat: VATRate
    var marqueRate: Double

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        productName: String,
        breakdown: MarginBreakdown
    ) {
        self.id = id
        self.createdAt = createdAt
        self.productName = productName
        self.paHT = breakdown.paHT
        self.pvTTC = breakdown.pvTTC
        self.vat = breakdown.vat
        self.marqueRate = breakdown.marqueRate
    }
}
