import SwiftUI

struct CalculatorView: View {
    @EnvironmentObject private var history: HistoryStore
    @State private var mode: Mode = .marge
    @State private var paHT = "6,90"
    @State private var pvTTC = "10,50"
    @State private var targetMarque = "35"
    @State private var ttcAmount = "10,50"
    @State private var vat: VATRate = .alimentaire
    @State private var productName = "Poulet fermier"
    @State private var savedPulse = false
    @FocusState private var focused: Bool
    @Namespace private var namespace

    enum Mode: String, CaseIterable {
        case marge = "Marge"
        case objectif = "Objectif"
        case tva = "TVA"
    }

    var breakdown: MarginBreakdown {
        MarginBreakdown(paHT: parse(paHT), pvTTC: parse(pvTTC), vat: vat)
    }

    var recommendedTTC: Double {
        CalculatorEngine.sellingPriceTTC(
            paHT: parse(paHT),
            targetMarque: parse(targetMarque) / 100,
            vat: vat
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    header
                    modePicker
                    vatChips
                    fields
                    results
                    if mode == .marge {
                        saveBlock
                        historyBlock
                    }
                }
                .padding(18)
                .padding(.bottom, 24)
            }
            .uSurface()
            .toolbar(.hidden, for: .navigationBar)
            .scrollDismissesKeyboard(.interactively)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Calculateur")
                    .font(UFont.display(30))
                    .foregroundStyle(UColor.encre)
                Text("Marges, marque, coefficient et TVA")
                    .font(UFont.body(14, weight: .medium))
                    .foregroundStyle(UColor.ardoise)
            }
            Spacer()
            Image(systemName: "function")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(UColor.headerGradient, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.top, 8)
    }

    private var modePicker: some View {
        HStack(spacing: 6) {
            ForEach(Mode.allCases, id: \.self) { item in
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.78)) {
                        mode = item
                    }
                } label: {
                    Text(item.rawValue)
                        .font(UFont.body(14, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundStyle(mode == item ? .white : UColor.bleuSignature)
                        .background {
                            if mode == item {
                                Capsule().fill(UColor.bleuSignature)
                                    .matchedGeometryEffect(id: "mode", in: namespace)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(5)
        .background(UColor.bleuSignature.opacity(0.1), in: Capsule())
    }

    private var vatChips: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Taux de TVA")
                .font(UFont.body(13, weight: .semibold))
                .foregroundStyle(UColor.ardoise)
            HStack(spacing: 8) {
                ForEach(VATRate.allCases) { rate in
                    Button {
                        withAnimation(.snappy) { vat = rate }
                    } label: {
                        VStack(spacing: 2) {
                            Text(rate.label)
                                .font(UFont.body(13, weight: .bold))
                            Text(rate.caption)
                                .font(UFont.body(9, weight: .medium))
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundStyle(vat == rate ? .white : UColor.encre)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(vat == rate ? UColor.rouge : .white)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    @ViewBuilder
    private var fields: some View {
        VStack(spacing: 14) {
            if mode != .tva {
                DecimalField(title: "Prix d'achat HT", suffix: "€", text: $paHT)
                    .focused($focused)
            }
            if mode == .marge {
                DecimalField(title: "Prix de vente TTC", suffix: "€", text: $pvTTC)
                TextField("Nom du produit (facultatif)", text: $productName)
                    .font(UFont.body(15, weight: .medium))
                    .padding(14)
                    .background(.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            } else if mode == .objectif {
                DecimalField(title: "Taux de marque visé", suffix: "%", text: $targetMarque)
            } else {
                DecimalField(title: "Montant TTC", suffix: "€", text: $ttcAmount)
            }
        }
        .uCard()
    }

    @ViewBuilder
    private var results: some View {
        switch mode {
        case .marge:
            margeResults
        case .objectif:
            objectifResults
        case .tva:
            tvaResults
        }
    }

    private var margeResults: some View {
        let r = breakdown
        return VStack(spacing: 14) {
            HStack(spacing: 16) {
                MarqueGauge(value: r.marqueRate)
                    .frame(width: 96, height: 96)
                VStack(alignment: .leading, spacing: 6) {
                    resultRow("PV HT", r.pvHT.euros)
                    resultRow("Marge brute", r.grossMargin.euros, emphasize: true)
                    resultRow("Coefficient", String(format: "× %.3f", r.coefficient).replacingOccurrences(of: ".", with: ","))
                }
            }
            Divider()
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                mini("Taux de marge", r.marginRate.percentFR, UColor.bleuSignature)
                mini("Taux de marque", r.marqueRate.percentFR, UColor.rouge)
                mini("TVA collectée", r.vatCollected.euros, UColor.vertEau)
                mini("TVA nette", r.vatNet.euros, UColor.bleuCiel)
            }
            if r.isLoss {
                Label("Attention : marge négative", systemImage: "exclamationmark.triangle.fill")
                    .font(UFont.body(13, weight: .semibold))
                    .foregroundStyle(UColor.rouge)
            }
        }
        .uCard()
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: r)
        .sensoryFeedback(.selection, trigger: r.marqueRate)
    }

    private var objectifResults: some View {
        let ttc = recommendedTTC
        let hypo = MarginBreakdown(paHT: parse(paHT), pvTTC: ttc, vat: vat)
        return VStack(alignment: .leading, spacing: 12) {
            Text("Prix de vente conseillé")
                .font(UFont.body(13, weight: .semibold))
                .foregroundStyle(UColor.ardoise)
            Text(ttc.euros)
                .font(UFont.display(36))
                .foregroundStyle(UColor.rouge)
                .contentTransition(.numericText())
            Text("Pour une marque de \((parse(targetMarque) / 100).percentFR) sur un achat à \(parse(paHT).euros) HT.")
                .font(UFont.body(13))
                .foregroundStyle(UColor.ardoise)
            Divider()
            resultRow("PV HT", hypo.pvHT.euros)
            resultRow("Marge unitaire", hypo.grossMargin.euros)
            resultRow("TVA collectée", hypo.vatCollected.euros)
            Button("Appliquer comme PV TTC") {
                pvTTC = format(ttc)
                withAnimation { mode = .marge }
            }
            .font(UFont.body(15, weight: .bold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .foregroundStyle(.white)
            .background(UColor.bleuSignature, in: Capsule())
        }
        .uCard()
        .animation(.snappy, value: ttc)
    }

    private var tvaResults: some View {
        let ttc = parse(ttcAmount)
        let ht = CalculatorEngine.ht(fromTTC: ttc, vat: vat)
        let vatAmount = CalculatorEngine.vatAmount(ht: ht, vat: vat)
        return VStack(spacing: 12) {
            resultRow("Montant HT", ht.euros)
            resultRow("TVA (\(vat.label))", vatAmount.euros, emphasize: true)
            resultRow("Montant TTC", ttc.euros)
            Text("Rappel : les produits alimentaires frais sont en 5,5 %. Le traiteur maison passe souvent en 10 %.")
                .font(UFont.body(12))
                .foregroundStyle(UColor.ardoise)
                .padding(.top, 4)
        }
        .uCard()
        .animation(.snappy, value: ttc)
        .animation(.snappy, value: vat)
    }

    private var saveBlock: some View {
        Button {
            let item = SavedCalculation(
                productName: productName.isEmpty ? "Calcul" : productName,
                breakdown: breakdown
            )
            history.save(item)
            withAnimation(.spring) { savedPulse = true }
            Task {
                try? await Task.sleep(for: .milliseconds(800))
                withAnimation { savedPulse = false }
            }
        } label: {
            Label(savedPulse ? "Enregistré" : "Sauver ce calcul", systemImage: savedPulse ? "checkmark.circle.fill" : "square.and.arrow.down")
                .font(UFont.body(16, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundStyle(.white)
                .background(savedPulse ? UColor.vertEau : UColor.rouge, in: Capsule())
        }
        .disabled(!breakdown.isValid)
        .sensoryFeedback(.success, trigger: savedPulse)
    }

    private var historyBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Historique")
                    .font(UFont.display(18))
                Spacer()
                if !history.items.isEmpty {
                    Button("Vider") { history.clear() }
                        .font(UFont.body(13, weight: .semibold))
                        .foregroundStyle(UColor.rouge)
                }
            }
            if history.items.isEmpty {
                Text("Aucun calcul enregistré pour le moment.")
                    .font(UFont.body(13))
                    .foregroundStyle(UColor.ardoise)
                    .uCard()
            } else {
                ForEach(history.items.prefix(8)) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(item.productName)
                                .font(UFont.body(14, weight: .semibold))
                            Text("PA \(item.paHT.euros) · PV \(item.pvTTC.euros) · \(item.vat.label)")
                                .font(UFont.body(12))
                                .foregroundStyle(UColor.ardoise)
                        }
                        Spacer()
                        Text(item.marqueRate.percentFR)
                            .font(UFont.body(15, weight: .bold))
                            .foregroundStyle(UColor.bleuSignature)
                    }
                    .uCard(padding: 12)
                }
            }
        }
    }

    private func resultRow(_ title: String, _ value: String, emphasize: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(UFont.body(13, weight: .medium))
                .foregroundStyle(UColor.ardoise)
            Spacer()
            Text(value)
                .font(UFont.body(emphasize ? 18 : 15, weight: .bold))
                .foregroundStyle(emphasize ? UColor.rouge : UColor.encre)
                .contentTransition(.numericText())
        }
    }

    private func mini(_ title: String, _ value: String, _ tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(UFont.body(11, weight: .medium))
                .foregroundStyle(UColor.ardoise)
            Text(value)
                .font(UFont.body(16, weight: .bold))
                .foregroundStyle(tint)
                .contentTransition(.numericText())
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tint.opacity(0.1), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func parse(_ raw: String) -> Double {
        let normalized = raw.replacingOccurrences(of: ",", with: ".")
            .filter { "0123456789.".contains($0) }
        return Double(normalized) ?? 0
    }

    private func format(_ value: Double) -> String {
        String(format: "%.2f", value).replacingOccurrences(of: ".", with: ",")
    }
}

#Preview {
    CalculatorView()
        .environmentObject(HistoryStore())
}
