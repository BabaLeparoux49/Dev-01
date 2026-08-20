import Foundation

enum SampleCatalog {
    static let products: [FreshProduct] = [
        item("Tomates grappe locales", "Maraîcher 44", "Ligné / Vallet", .fruitsLegumes, 1.62, 2.89, 42, 8, 38, 36, false, "kg", [18, 21, 19, 24, 28, 31, 38]),
        item("Fraises Gariguette", "U Saveurs", "France", .fruitsLegumes, 4.80, 7.95, 18, 5, 22, 20, true, "barq. 250 g", [12, 14, 16, 15, 18, 20, 22]),
        item("Melon charentais", "U", "France", .fruitsLegumes, 1.35, 2.49, 26, 6, 19, 48, false, "pce", [8, 9, 11, 13, 14, 16, 19]),
        item("Courgettes Loire-Atlantique", "Local", "Pays de Retz", .fruitsLegumes, 0.92, 1.69, 54, 10, 41, 40, false, "kg", [20, 24, 22, 28, 33, 37, 41]),
        item("Asperges blanches", "U Saveurs", "France", .fruitsLegumes, 6.40, 9.90, 9, 3, 11, 16, false, "botte", [4, 5, 6, 7, 8, 9, 11]),
        item("Avocat Hass extra", "U", "Pérou", .fruitsLegumes, 0.78, 1.49, 48, 12, 27, 72, false, "pce", [14, 16, 18, 19, 22, 24, 27]),
        item("Salade feuille de chêne", "Local", "Ligné", .fruitsLegumes, 0.55, 1.15, 36, 8, 24, 18, false, "pce", [10, 12, 14, 16, 18, 21, 24]),

        item("Entrecôte race à viande", "U Saveurs", "France", .boucherie, 16.80, 25.90, 14, 4, 9, 30, false, "kg", [5, 6, 6, 7, 8, 8, 9]),
        item("Côte de bœuf maturée 21 j", "Boucherie Ligné", "France", .boucherie, 21.40, 34.90, 6, 2, 4, 28, false, "kg", [1, 1, 2, 2, 3, 3, 4]),
        item("Poulet fermier Label Rouge", "U", "Vendée", .boucherie, 6.90, 10.50, 22, 6, 17, 36, false, "pce", [8, 10, 11, 12, 14, 15, 17]),
        item("Steak haché 15 % 1 kg", "U", "France", .boucherie, 6.20, 8.95, 31, 8, 28, 24, true, "kg", [12, 16, 18, 20, 22, 25, 28]),
        item("Rôti de porc label", "U", "Bretagne", .boucherie, 5.40, 8.49, 16, 4, 12, 40, false, "kg", [6, 7, 8, 9, 10, 11, 12]),
        item("Saucisses de Toulouse", "Rayon", "France", .boucherie, 5.80, 8.90, 19, 5, 14, 22, false, "kg", [5, 7, 8, 9, 11, 12, 14]),

        item("Bar de ligne", "Marée du jour", "Atlantique", .poissonnerie, 17.20, 26.90, 8, 3, 7, 10, false, "kg", [2, 3, 3, 4, 5, 6, 7]),
        item("Lieu jaune filet", "U", "Bretagne", .poissonnerie, 11.50, 18.50, 11, 4, 9, 12, false, "kg", [3, 4, 5, 6, 7, 8, 9]),
        item("Saumon entier Label Rouge", "U Saveurs", "Écosse", .poissonnerie, 9.80, 15.90, 10, 3, 8, 20, true, "kg", [3, 4, 4, 5, 6, 7, 8]),
        item("Huîtres Marennes n°3", "Local", "Marennes-Oléron", .poissonnerie, 6.40, 11.90, 12, 4, 6, 18, false, "dz", [1, 2, 2, 3, 4, 5, 6]),
        item("Saint-Jacques noix", "Marée du jour", "Nantes / Bretagne", .poissonnerie, 22.00, 34.90, 5, 2, 4, 8, false, "kg", [1, 1, 2, 2, 3, 3, 4]),
        item("Crevettes tigrées cuites", "U", "Équateur", .poissonnerie, 8.90, 13.90, 15, 5, 11, 16, false, "kg", [4, 5, 6, 7, 8, 10, 11]),

        item("Jambon blanc supérieur", "U", "France", .charcuterie, 7.40, 11.50, 18, 6, 16, 72, false, "kg", [7, 9, 10, 12, 13, 14, 16]),
        item("Pâté de campagne U", "U", "France", .charcuterie, 3.10, 5.35, 22, 6, 13, 96, false, "pce", [5, 6, 7, 8, 10, 11, 13]),
        item("Rillettes du Mans", "U Saveurs", "Sarthe", .charcuterie, 2.45, 4.29, 20, 5, 12, 80, false, "pot", [4, 5, 6, 7, 9, 10, 12]),
        item("Andouille de Guéméné", "Local", "Bretagne", .charcuterie, 9.80, 15.90, 7, 3, 5, 60, false, "kg", [1, 2, 2, 3, 4, 4, 5]),

        item("Camembert AOP", "U Saveurs", "Normandie", .cremerie, 1.55, 2.79, 34, 8, 21, 48, false, "pce", [9, 11, 13, 15, 17, 19, 21]),
        item("Comté 18 mois", "U Saveurs", "Jura", .cremerie, 14.20, 24.90, 8, 3, 6, 90, false, "kg", [2, 3, 3, 4, 5, 5, 6]),
        item("Beurre moulé doux 250 g", "U", "France", .cremerie, 1.72, 2.65, 48, 10, 33, 120, false, "pce", [16, 18, 21, 24, 27, 30, 33]),
        item("Œufs plein air x12", "U", "Pays de la Loire", .cremerie, 2.10, 3.49, 40, 8, 29, 168, false, "boîte", [12, 15, 18, 20, 23, 26, 29]),
        item("Yaourt brassé nature x8", "U", "France", .cremerie, 1.28, 2.15, 52, 12, 31, 96, false, "pack", [14, 17, 19, 22, 25, 28, 31]),
        item("Chèvre fermier Sainte-Maure", "Local", "Anjou", .cremerie, 3.40, 5.95, 9, 3, 7, 36, false, "pce", [2, 3, 4, 4, 5, 6, 7]),

        item("Blanquette de veau 2 pers.", "Traiteur", "Fait maison", .traiteur, 6.80, 12.90, 11, 4, 8, 14, false, "barq.", [3, 4, 5, 5, 6, 7, 8], vat: .intermediaire),
        item("Gratin dauphinois", "Traiteur", "Fait maison", .traiteur, 3.20, 6.50, 16, 5, 12, 16, false, "barq.", [4, 5, 6, 7, 9, 10, 12], vat: .intermediaire),
        item("Plateau apéro Ligné", "Traiteur", "Fait maison", .traiteur, 8.40, 16.90, 7, 3, 5, 10, true, "pce", [1, 2, 2, 3, 4, 4, 5], vat: .intermediaire),
        item("Salade composée saumon", "Traiteur", "Fait maison", .traiteur, 3.90, 7.50, 14, 4, 10, 12, false, "barq.", [3, 4, 5, 6, 7, 8, 10], vat: .intermediaire),

        item("Baguette Tradition", "Fournée", "Ligné", .boulangerie, 0.42, 1.05, 86, 16, 74, 8, false, "pce", [30, 38, 45, 52, 60, 67, 74]),
        item("Pain au chocolat", "Fournée", "Ligné", .boulangerie, 0.48, 1.20, 64, 12, 51, 6, false, "pce", [18, 24, 30, 36, 42, 46, 51]),
        item("Tarte aux fruits 6 parts", "Pâtisserie", "Ligné", .boulangerie, 4.80, 9.90, 8, 3, 6, 12, false, "pce", [1, 2, 2, 3, 4, 5, 6]),
        item("Brioche tressée", "Fournée", "Ligné", .boulangerie, 1.85, 3.49, 14, 4, 9, 20, false, "pce", [3, 4, 5, 6, 7, 8, 9])
    ]

    private static func item(
        _ name: String,
        _ brand: String,
        _ origin: String,
        _ rayon: RayonKind,
        _ paHT: Double,
        _ pvTTC: Double,
        _ stock: Int,
        _ facing: Int,
        _ sold: Int,
        _ dlcHours: Int?,
        _ promo: Bool,
        _ unit: String,
        _ trend: [Double],
        vat: VATRate? = nil
    ) -> FreshProduct {
        FreshProduct(
            id: UUID(),
            name: name,
            brand: brand,
            origin: origin,
            rayon: rayon,
            paHT: paHT,
            pvTTC: pvTTC,
            vat: vat ?? rayon.defaultVAT,
            stock: stock,
            facing: facing,
            unitsSoldToday: sold,
            dlcHours: dlcHours,
            isPromo: promo,
            unit: unit,
            vaTrend: trend
        )
    }
}
