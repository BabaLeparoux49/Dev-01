import SwiftUI

struct ProductDetailView: View {
    var productID: UUID
    @EnvironmentObject private var feed: LiveFeedService
    @EnvironmentObject private var history: HistoryStore
    @State private var appear = false

    var product: FreshProduct? {
        feed.products.first { $0.id == productID }
    }

    var body: some View {
        Group {
            if let product {
                content(product)
            } else {
                ContentUnavailableView("Produit introuvable", systemImage: "basket")
            }
        }
        .background(UColor.creme.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }

    private func content(_ product: FreshProduct) -> some View {
        let r = product.breakdown
        return ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [product.rayon.tint, product.rayon.tint.opacity(0.7), UColor.bleuSignature],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 168)
                        .overlay(alignment: .topTrailing) {
                            Image(systemName: product.rayon.symbol)
                                .font(.system(size: 64, weight: .bold))
                                .foregroundStyle(.white.opacity(0.18))
                                .offset(x: -12, y: 18)
                                .scaleEffect(appear ? 1 : 0.7)
                        }

                    VStack(alignment: .leading, spacing: 6) {
                        Text(product.rayon.title.uppercased())
                            .font(UFont.body(11, weight: .heavy))
                            .foregroundStyle(.white.opacity(0.8))
                        Text(product.name)
                            .font(UFont.display(26))
                            .foregroundStyle(.white)
                        Text("\(product.brand) · \(product.origin)")
                            .font(UFont.body(13, weight: .medium))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .padding(20)
                }
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 12)

                HStack(spacing: 12) {
                    MarqueGauge(value: r.marqueRate)
                        .frame(width: 100, height: 100)
                    VStack(alignment: .leading, spacing: 8) {
                        metric("PV TTC", product.pvTTC.euros)
                        metric("PA HT", product.paHT.euros)
                        metric("Marge", r.grossMargin.euros)
                    }
                    Spacer()
                }
                .uCard()

                VStack(spacing: 10) {
                    metric("Taux de marge", r.marginRate.percentFR)
                    metric("Taux de marque", r.marqueRate.percentFR)
                    metric("Coefficient", String(format: "× %.3f", r.coefficient).replacingOccurrences(of: ".", with: ","))
                    metric("TVA", product.vat.label)
                    metric("TVA collectée", r.vatCollected.euros)
                    metric("TVA nette", r.vatNet.euros)
                    metric("Contribution jour", product.contributionToday.euros)
                    metric("Ventes du jour", "\(product.unitsSoldToday) \(product.unit)")
                    metric("Stock", "\(product.stock) \(product.unit)")
                    if let dlc = product.dlcHours {
                        metric("DLC estimée", "\(dlc) h")
                    }
                }
                .uCard()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Dynamique des ventes")
                        .font(UFont.body(14, weight: .semibold))
                    Sparkline(values: product.vaTrend, tint: product.rayon.tint)
                        .frame(height: 56)
                }
                .uCard()

                if product.stockAlert || product.dlcAlert {
                    Label(
                        product.stockAlert ? "Réassort à anticiper" : "DLC courte — démarque ou mise en avant",
                        systemImage: "exclamationmark.triangle.fill"
                    )
                    .font(UFont.body(14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(UColor.rouge, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                }

                Button {
                    history.save(SavedCalculation(productName: product.name, breakdown: r))
                } label: {
                    Label("Enregistrer dans le calculateur", systemImage: "plus.circle.fill")
                        .font(UFont.body(16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundStyle(.white)
                        .background(UColor.bleuSignature, in: Capsule())
                }
            }
            .padding(18)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                appear = true
            }
        }
    }

    private func metric(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .font(UFont.body(13, weight: .medium))
                .foregroundStyle(UColor.ardoise)
            Spacer()
            Text(value)
                .font(UFont.body(15, weight: .bold))
                .foregroundStyle(UColor.encre)
                .contentTransition(.numericText())
        }
    }
}
