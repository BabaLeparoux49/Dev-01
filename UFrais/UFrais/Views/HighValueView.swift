import SwiftUI

struct HighValueView: View {
    @EnvironmentObject private var feed: LiveFeedService
    @State private var ranking: Ranking = .contribution
    @State private var rayonFilter: RayonKind?
    @Namespace private var chipNS

    enum Ranking: String, CaseIterable {
        case contribution = "Contribution"
        case marque = "Marque"
        case alertes = "Alertes"
    }

    var filtered: [FreshProduct] {
        let base: [FreshProduct]
        switch ranking {
        case .contribution: base = feed.topVA
        case .marque: base = feed.topMarque
        case .alertes: base = feed.products.filter { $0.stockAlert || $0.dlcAlert }
        }
        if let rayonFilter {
            return base.filter { $0.rayon == rayonFilter }
        }
        return base
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    header
                    rankingPicker
                    rayonScroller
                    eventRail
                    productList
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 28)
            }
            .uSurface()
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Forte VA")
                        .font(UFont.display(30))
                    Text("Produits à forte valeur ajoutée, rayon par rayon, en direct.")
                        .font(UFont.body(14, weight: .medium))
                        .foregroundStyle(UColor.ardoise)
                }
                Spacer()
                Button {
                    withAnimation(.snappy) { feed.toggle() }
                } label: {
                    LiveBadge(isLive: feed.isLive)
                }
                .buttonStyle(.plain)
            }

            HStack {
                Label("Mis à jour", systemImage: "dot.radiowaves.left.and.right")
                Text(feed.lastUpdate, style: .relative)
                Text("·")
                Text("\(feed.tickCount) impulsions")
            }
            .font(UFont.body(12, weight: .semibold))
            .foregroundStyle(UColor.bleuSignature)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(UColor.bleuCiel.opacity(0.18), in: Capsule())
        }
        .padding(.top, 8)
    }

    private var rankingPicker: some View {
        HStack(spacing: 6) {
            ForEach(Ranking.allCases, id: \.self) { item in
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.78)) {
                        ranking = item
                    }
                } label: {
                    Text(item.rawValue)
                        .font(UFont.body(13, weight: .bold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .foregroundStyle(ranking == item ? .white : UColor.encre)
                        .background {
                            if ranking == item {
                                Capsule()
                                    .fill(UColor.rouge)
                                    .matchedGeometryEffect(id: "rank", in: chipNS)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
        .padding(5)
        .background(.white, in: Capsule())
    }

    private var rayonScroller: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Button {
                    withAnimation(.snappy) { rayonFilter = nil }
                } label: {
                    Text("Tous les rayons")
                        .font(UFont.body(13, weight: .semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .foregroundStyle(rayonFilter == nil ? .white : UColor.bleuSignature)
                        .background(Capsule().fill(rayonFilter == nil ? UColor.bleuSignature : UColor.bleuSignature.opacity(0.12)))
                }
                .buttonStyle(.plain)

                ForEach(RayonKind.allCases) { rayon in
                    Button {
                        withAnimation(.snappy) {
                            rayonFilter = rayonFilter == rayon ? nil : rayon
                        }
                    } label: {
                        RayonChip(rayon: rayon, selected: rayonFilter == rayon)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var eventRail: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Fil d'actualités")
                .font(UFont.display(16))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(feed.events.prefix(10)) { event in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: event.symbol)
                                    .foregroundStyle(event.tint)
                                Text(event.date, style: .time)
                                    .font(UFont.body(11, weight: .semibold))
                                    .foregroundStyle(UColor.ardoise)
                            }
                            Text(event.title)
                                .font(UFont.body(13, weight: .bold))
                                .foregroundStyle(UColor.encre)
                                .lineLimit(2)
                            Text(event.rayon.title)
                                .font(UFont.body(11, weight: .medium))
                                .foregroundStyle(event.tint)
                        }
                        .padding(12)
                        .frame(width: 210, alignment: .leading)
                        .background(.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(event.tint.opacity(0.2), lineWidth: 1)
                        )
                    }
                }
            }
        }
    }

    private var productList: some View {
        LazyVStack(spacing: 12) {
            ForEach(Array(filtered.enumerated()), id: \.element.id) { index, product in
                NavigationLink {
                    ProductDetailView(productID: product.id)
                } label: {
                    VAProductCard(product: product, rank: index + 1)
                }
                .buttonStyle(.plain)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .opacity
                ))
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.82), value: filtered.map(\.id))
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: feed.tickCount)
    }
}

struct VAProductCard: View {
    var product: FreshProduct
    var rank: Int

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(product.rayon.tint.opacity(0.14))
                VStack(spacing: 2) {
                    Text("\(rank)")
                        .font(UFont.display(18))
                        .foregroundStyle(product.rayon.tint)
                    Image(systemName: product.rayon.symbol)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(product.rayon.tint)
                }
            }
            .frame(width: 54, height: 64)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(product.name)
                        .font(UFont.body(15, weight: .bold))
                        .foregroundStyle(UColor.encre)
                        .lineLimit(1)
                    if product.isPromo {
                        Text("PROMO")
                            .font(UFont.body(9, weight: .heavy))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(UColor.rouge, in: Capsule())
                    }
                }
                Text("\(product.brand) · \(product.origin)")
                    .font(UFont.body(12))
                    .foregroundStyle(UColor.ardoise)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Label(product.contributionToday.euros, systemImage: "plus.forwardslash.minus")
                    Label(product.breakdown.marqueRate.percentFR, systemImage: "tag.fill")
                    if product.stockAlert {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(UColor.rouge)
                    }
                    if product.dlcAlert {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(.orange)
                    }
                }
                .font(UFont.body(11, weight: .semibold))
                .foregroundStyle(UColor.bleuSignature)

                Sparkline(values: product.vaTrend, tint: product.rayon.tint)
                    .frame(height: 22)
            }
        }
        .padding(12)
        .background(.white, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: product.rayon.tint.opacity(0.1), radius: 12, y: 6)
    }
}

#Preview {
    HighValueView()
        .environmentObject(LiveFeedService())
}
