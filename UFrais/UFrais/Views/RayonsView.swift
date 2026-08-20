import SwiftUI

struct RayonsView: View {
    @EnvironmentObject private var feed: LiveFeedService

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Rayons")
                            .font(UFont.display(30))
                        Text("Vue d'ensemble des produits frais — Super U Ligné")
                            .font(UFont.body(14, weight: .medium))
                            .foregroundStyle(UColor.ardoise)
                    }
                    .padding(.top, 8)

                    ForEach(feed.snapshots()) { snap in
                        NavigationLink {
                            RayonDetailView(rayon: snap.kind)
                        } label: {
                            RayonCard(snapshot: snap)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(18)
                .padding(.bottom, 24)
            }
            .uSurface()
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct RayonCard: View {
    var snapshot: RayonSnapshot
    @State private var appear = false

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(snapshot.kind.tint.opacity(0.16))
                Image(systemName: snapshot.kind.symbol)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(snapshot.kind.tint)
                    .symbolEffect(.pulse, value: snapshot.dlc + snapshot.ruptures)
            }
            .frame(width: 58, height: 58)

            VStack(alignment: .leading, spacing: 6) {
                Text(snapshot.kind.title)
                    .font(UFont.body(17, weight: .bold))
                    .foregroundStyle(UColor.encre)
                HStack(spacing: 10) {
                    Text("CA \(snapshot.caTTC.euros)")
                    Text("Marge \(snapshot.marge.euros)")
                }
                .font(UFont.body(12, weight: .medium))
                .foregroundStyle(UColor.ardoise)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                Text(snapshot.marque.percentFR)
                    .font(UFont.display(16))
                    .foregroundStyle(snapshot.kind.tint)
                    .contentTransition(.numericText())
                if snapshot.ruptures + snapshot.dlc > 0 {
                    Text("\(snapshot.ruptures + snapshot.dlc) alerte\(snapshot.ruptures + snapshot.dlc > 1 ? "s" : "")")
                        .font(UFont.body(11, weight: .bold))
                        .foregroundStyle(UColor.rouge)
                } else {
                    Text("OK")
                        .font(UFont.body(11, weight: .bold))
                        .foregroundStyle(UColor.vertEau)
                }
            }
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(UColor.ardoise.opacity(0.5))
        }
        .uCard()
        .opacity(appear ? 1 : 0)
        .offset(x: appear ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.8).delay(Double(RayonKind.allCases.firstIndex(of: snapshot.kind) ?? 0) * 0.05)) {
                appear = true
            }
        }
    }
}

struct RayonDetailView: View {
    var rayon: RayonKind
    @EnvironmentObject private var feed: LiveFeedService

    var items: [FreshProduct] {
        feed.products(in: rayon)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 14) {
                if let snap = feed.snapshots().first(where: { $0.kind == rayon }) {
                    HStack {
                        MarqueGauge(value: snap.marque)
                            .frame(width: 88, height: 88)
                        VStack(alignment: .leading, spacing: 8) {
                            result("CA du jour", snap.caTTC.euros)
                            result("Marge brute", snap.marge.euros)
                            result("Alertes", "\(snap.ruptures + snap.dlc)")
                        }
                        Spacer()
                    }
                    .uCard()
                }

                ForEach(items) { product in
                    NavigationLink {
                        ProductDetailView(productID: product.id)
                    } label: {
                        VAProductCard(product: product, rank: (items.firstIndex(of: product) ?? 0) + 1)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(18)
        }
        .background(UColor.creme.ignoresSafeArea())
        .navigationTitle(rayon.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func result(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .font(UFont.body(13))
                .foregroundStyle(UColor.ardoise)
            Spacer()
            Text(value)
                .font(UFont.body(15, weight: .bold))
        }
    }
}

#Preview {
    RayonsView()
        .environmentObject(LiveFeedService())
}
