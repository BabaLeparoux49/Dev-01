import SwiftUI

struct ConcurrentView: View {
    @State private var showScanner = false
    @State private var barcode = ""
    @State private var product: ScannedProduct?
    @State private var isLookingUp = false
    @State private var errorMessage: String?
    @State private var myPrice = ""
    @State private var competitorPrice = ""
    @State private var competitorName = "Concurrent"
    @State private var paHT = ""
    @State private var vat: VATRate = .alimentaire
    @FocusState private var focusField: Field?

    enum Field { case my, competitor, pa, barcode }

    var gap: CompetitorGap? {
        let mine = parse(myPrice)
        let theirs = parse(competitorPrice)
        guard mine > 0, theirs > 0 else { return nil }
        return CompetitorGap(myPriceTTC: mine, competitorPriceTTC: theirs)
    }

    var myBreakdown: MarginBreakdown? {
        let pa = parse(paHT)
        let pv = parse(myPrice)
        guard pa > 0, pv > 0 else { return nil }
        return MarginBreakdown(paHT: pa, pvTTC: pv, vat: vat)
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    header
                    scanBlock
                    if let product {
                        productCard(product)
                    }
                    priceFields
                    if let gap {
                        gapCard(gap)
                    }
                    if let mine = myBreakdown {
                        marginCard(mine)
                    }
                    webSearchButton
                }
                .padding(18)
                .padding(.bottom, 28)
            }
            .uSurface()
            .toolbar(.hidden, for: .navigationBar)
            .scrollDismissesKeyboard(.interactively)
            .sheet(isPresented: $showScanner) {
                BarcodeScannerSheet { code in
                    barcode = code
                    Task { await lookup(code) }
                }
                .presentationDetents([.large])
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Concurrent")
                    .font(UFont.display(30))
                    .foregroundStyle(UColor.encre)
                Text("Scan → fiche produit → compare ton prix au leur")
                    .font(UFont.body(14, weight: .medium))
                    .foregroundStyle(UColor.ardoise)
            }
            Spacer()
            Image(systemName: "barcode.viewfinder")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(UColor.headerGradient, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.top, 8)
    }

    private var scanBlock: some View {
        VStack(spacing: 12) {
            Button {
                showScanner = true
            } label: {
                Label("Scanner un code-barres", systemImage: "camera.fill")
                    .font(UFont.body(16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .foregroundStyle(.white)
                    .background(UColor.rouge, in: Capsule())
            }

            HStack {
                TextField("EAN / code-barres", text: $barcode)
                    .keyboardType(.numberPad)
                    .focused($focusField, equals: .barcode)
                    .font(UFont.body(16, weight: .semibold))
                Button {
                    Task { await lookup(barcode) }
                } label: {
                    if isLookingUp {
                        ProgressView()
                    } else {
                        Text("OK")
                            .font(UFont.body(14, weight: .bold))
                    }
                }
                .foregroundStyle(UColor.bleuSignature)
                .disabled(isLookingUp)
            }
            .padding(14)
            .background(UColor.creme, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

            if let errorMessage {
                Text(errorMessage)
                    .font(UFont.body(12, weight: .medium))
                    .foregroundStyle(UColor.rouge)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .uCard()
    }

    private func productCard(_ product: ScannedProduct) -> some View {
        HStack(spacing: 12) {
            AsyncImage(url: product.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Image(systemName: "cart.fill")
                        .foregroundStyle(UColor.bleuSignature)
                }
            }
            .frame(width: 64, height: 64)
            .background(UColor.creme)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(UFont.body(15, weight: .bold))
                    .foregroundStyle(UColor.encre)
                    .lineLimit(2)
                if let brand = product.brand {
                    Text(brand)
                        .font(UFont.body(12, weight: .medium))
                        .foregroundStyle(UColor.ardoise)
                }
                Text("EAN \(product.barcode)")
                    .font(UFont.body(11, weight: .semibold))
                    .foregroundStyle(UColor.bleuSignature)
                if let quantity = product.quantity {
                    Text(quantity)
                        .font(UFont.body(11))
                        .foregroundStyle(UColor.ardoise)
                }
            }
            Spacer(minLength: 0)
        }
        .uCard()
    }

    private var priceFields: some View {
        VStack(spacing: 12) {
            TextField("Nom du concurrent (ex. Leclerc)", text: $competitorName)
                .font(UFont.body(14, weight: .medium))
                .padding(12)
                .background(UColor.creme, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            DecimalField(title: "Ton prix TTC (Super U)", suffix: "€", text: $myPrice)
                .focused($focusField, equals: .my)
            DecimalField(title: "Prix concurrent TTC", suffix: "€", text: $competitorPrice)
                .focused($focusField, equals: .competitor)

            Divider()

            Text("Optionnel — pour la marge sur ton prix")
                .font(UFont.body(12, weight: .semibold))
                .foregroundStyle(UColor.ardoise)
                .frame(maxWidth: .infinity, alignment: .leading)

            DecimalField(title: "Ton PA HT", suffix: "€", text: $paHT)
                .focused($focusField, equals: .pa)

            HStack(spacing: 8) {
                ForEach(VATRate.allCases) { rate in
                    Button {
                        withAnimation(.snappy) { vat = rate }
                    } label: {
                        Text(rate.label)
                            .font(UFont.body(12, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .foregroundStyle(vat == rate ? .white : UColor.encre)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(vat == rate ? UColor.rouge : UColor.creme)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .uCard()
    }

    private func gapCard(_ gap: CompetitorGap) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(gap.verdict)
                .font(UFont.display(22))
                .foregroundStyle(gap.isAligned ? UColor.vertEau : (gap.iAmMoreExpensive ? UColor.rouge : UColor.bleuSignature))

            HStack {
                metric("Écart", gap.difference.euros)
                metric("% vs \(competitorName)", gap.percentVsCompetitor.percentFR)
            }

            Text("Ton prix \(gap.myPriceTTC.euros) · \(competitorName) \(gap.competitorPriceTTC.euros)")
                .font(UFont.body(13))
                .foregroundStyle(UColor.ardoise)
        }
        .uCard()
        .animation(.snappy, value: gap)
        .sensoryFeedback(.selection, trigger: gap.difference)
    }

    private func marginCard(_ mine: MarginBreakdown) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sur ton prix Super U")
                .font(UFont.body(14, weight: .semibold))
            HStack {
                metric("Marque", mine.marqueRate.percentFR)
                metric("Marge", mine.grossMargin.euros)
            }
        }
        .uCard()
    }

    private var webSearchButton: some View {
        let query = product?.displayName ?? barcode
        return Group {
            if let url = searchURL(for: query) {
                Link(destination: url) {
                    Label("Chercher le produit sur le web", systemImage: "globe")
                        .font(UFont.body(15, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundStyle(.white)
                        .background(UColor.bleuSignature, in: Capsule())
                }
            }
        }
    }

    private func searchURL(for query: String) -> URL? {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty,
              let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(string: "https://www.google.com/search?q=\(encoded)+prix")
    }

    private func metric(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(UFont.body(11, weight: .medium))
                .foregroundStyle(UColor.ardoise)
            Text(value)
                .font(UFont.body(16, weight: .bold))
                .foregroundStyle(UColor.encre)
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(UColor.creme, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func lookup(_ code: String) async {
        let cleaned = code.filter(\.isNumber)
        guard cleaned.count >= 8 else {
            errorMessage = "Code trop court."
            return
        }
        isLookingUp = true
        errorMessage = nil
        defer { isLookingUp = false }
        do {
            product = try await OpenFoodFactsClient.lookup(barcode: cleaned)
            barcode = cleaned
        } catch {
            product = nil
            errorMessage = error.localizedDescription
        }
    }

    private func parse(_ raw: String) -> Double {
        let normalized = raw.replacingOccurrences(of: ",", with: ".")
            .filter { "0123456789.".contains($0) }
        return Double(normalized) ?? 0
    }
}

#Preview {
    ConcurrentView()
}
