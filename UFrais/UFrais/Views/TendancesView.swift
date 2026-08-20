import SwiftUI

struct TendancesView: View {
    @EnvironmentObject private var trends: TrendFeedService
    @State private var categoryFilter: TrendCategory = .vogue
    @State private var rayonFilter: RayonKind?
    @State private var appear = false

    var filtered: [TrendingProduct] {
        trends.items(in: rayonFilter, category: categoryFilter)
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    header
                    categoryPicker
                    filters
                    if let error = trends.lastError {
                        Text(error)
                            .font(UFont.body(12, weight: .medium))
                            .foregroundStyle(UColor.ardoise)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    list
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 28)
            }
            .uSurface()
            .toolbar(.hidden, for: .navigationBar)
            .refreshable { await trends.refresh() }
            .task {
                await trends.refreshIfNeededForToday()
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tendances")
                        .font(UFont.display(30))
                    Text(headerSubtitle)
                        .font(UFont.body(14, weight: .medium))
                        .foregroundStyle(UColor.ardoise)
                }
                Spacer()
                Button {
                    Task { await trends.refresh() }
                } label: {
                    Image(systemName: trends.isLoading ? "arrow.triangle.2.circlepath" : "arrow.clockwise")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(UColor.headerGradient, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .opacity(trends.isLoading ? 0.55 : 1)
                }
                .disabled(trends.isLoading)
            }

            HStack(spacing: 8) {
                Image(systemName: "calendar")
                Text("Chaque jour")
                Text("·")
                if let date = trends.updatedAt {
                    Text(date, format: .dateTime.day().month().hour().minute())
                } else {
                    Text("Aujourd'hui")
                }
                Text("·")
                Text(trends.feedOrigin)
                    .lineLimit(1)
            }
            .font(UFont.body(11, weight: .semibold))
            .foregroundStyle(UColor.bleuSignature)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(UColor.bleuCiel.opacity(0.18), in: Capsule())

            if !trends.sourceNote.isEmpty {
                Text(trends.sourceNote)
                    .font(UFont.body(12))
                    .foregroundStyle(UColor.ardoise)
            }
        }
        .padding(.top, 8)
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.8)) { appear = true }
        }
    }

    private var headerSubtitle: String {
        switch categoryFilter {
        case .vogue:
            return trends.headline
        case .nouveaute:
            return "Marques nationales connues — sorties & références rayon"
        }
    }

    private var categoryPicker: some View {
        HStack(spacing: 8) {
            ForEach(TrendCategory.allCases) { category in
                Button {
                    withAnimation(.snappy) {
                        categoryFilter = category
                        rayonFilter = nil
                    }
                } label: {
                    Label(category.title, systemImage: category.symbol)
                        .font(UFont.body(13, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundStyle(categoryFilter == category ? .white : UColor.bleuSignature)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(categoryFilter == category ? UColor.bleuSignature : UColor.bleuSignature.opacity(0.12))
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var filters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Button {
                    withAnimation(.snappy) { rayonFilter = nil }
                } label: {
                    Text("Tous")
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

    private var list: some View {
        LazyVStack(spacing: 12) {
            if filtered.isEmpty {
                ContentUnavailableView(
                    categoryFilter == .nouveaute ? "Aucune nouveauté" : "Aucune tendance",
                    systemImage: categoryFilter.symbol,
                    description: Text("Tire pour actualiser le fil.")
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ForEach(Array(filtered.enumerated()), id: \.element.id) { index, item in
                    NavigationLink {
                        TrendDetailView(productID: item.id)
                    } label: {
                        TrendCard(product: item, rank: index + 1)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: filtered.map(\.id))
    }
}

struct TrendCard: View {
    var product: TrendingProduct
    var rank: Int

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(product.rayon.tint.opacity(0.14))
                if let url = product.resolvedImageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            rankFallback
                        case .empty:
                            ProgressView()
                                .controlSize(.small)
                        @unknown default:
                            rankFallback
                        }
                    }
                    .frame(width: 64, height: 72)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                } else {
                    rankFallback
                }
            }
            .frame(width: 64, height: 72)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(product.name)
                        .font(UFont.body(15, weight: .bold))
                        .foregroundStyle(UColor.encre)
                        .lineLimit(1)
                    Text(product.heat.label)
                        .font(UFont.body(9, weight: .heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(product.heat.tint, in: Capsule())
                }
                Text(product.subtitle)
                    .font(UFont.body(12))
                    .foregroundStyle(UColor.ardoise)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    if product.resolvedCategory == .nouveaute {
                        Label("Marque", systemImage: "sparkles")
                    } else {
                        Label("Buzz \(product.buzzScore)", systemImage: "flame.fill")
                    }
                    Text(product.platforms.prefix(2).joined(separator: " · "))
                        .lineLimit(1)
                }
                .font(UFont.body(11, weight: .semibold))
                .foregroundStyle(UColor.bleuSignature)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(UColor.ardoise.opacity(0.5))
        }
        .padding(12)
        .background(.white, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: product.rayon.tint.opacity(0.1), radius: 12, y: 6)
    }

    private var rankFallback: some View {
        VStack(spacing: 2) {
            Text("\(rank)")
                .font(UFont.display(18))
                .foregroundStyle(product.rayon.tint)
            Image(systemName: product.rayon.symbol)
                .font(.caption.weight(.bold))
                .foregroundStyle(product.rayon.tint)
        }
    }
}

struct TrendDetailView: View {
    var productID: String
    @EnvironmentObject private var trends: TrendFeedService
    @State private var appear = false

    var product: TrendingProduct? {
        trends.items.first { $0.id == productID }
    }

    var body: some View {
        Group {
            if let product {
                content(product)
            } else {
                ContentUnavailableView("Tendance introuvable", systemImage: "sparkles")
            }
        }
        .background(UColor.creme.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }

    private func content(_ product: TrendingProduct) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                ZStack(alignment: .bottomLeading) {
                    Group {
                        if let url = product.resolvedImageURL {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                default:
                                    heroGradient(product)
                                }
                            }
                        } else {
                            heroGradient(product)
                        }
                    }
                    .frame(height: 220)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .overlay {
                        LinearGradient(
                            colors: [.black.opacity(0.05), .black.opacity(0.55)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))

                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Text(product.rayon.title.uppercased())
                                .font(UFont.body(11, weight: .heavy))
                                .foregroundStyle(.white.opacity(0.8))
                            if product.resolvedCategory == .nouveaute {
                                Text("NOUVEAUTÉ")
                                    .font(UFont.body(10, weight: .heavy))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(UColor.rouge.opacity(0.9), in: Capsule())
                            }
                        }
                        Text(product.name)
                            .font(UFont.display(24))
                            .foregroundStyle(.white)
                        Text(product.subtitle)
                            .font(UFont.body(13, weight: .medium))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .padding(20)
                }
                .opacity(appear ? 1 : 0)

                HStack {
                    Label(product.heat.label, systemImage: "flame.fill")
                        .foregroundStyle(product.heat.tint)
                    Spacer()
                    Text(product.resolvedCategory == .nouveaute ? "Score \(product.buzzScore)/100" : "Buzz \(product.buzzScore)/100")
                        .font(UFont.body(15, weight: .bold))
                        .foregroundStyle(UColor.encre)
                }
                .font(UFont.body(14, weight: .semibold))
                .uCard()

                if let barcode = product.barcode, !barcode.isEmpty {
                    HStack {
                        Image(systemName: "barcode")
                        Text("EAN \(barcode)")
                            .font(UFont.body(13, weight: .semibold))
                        Spacer()
                        Text(product.rayon.title)
                            .font(UFont.body(12, weight: .medium))
                            .foregroundStyle(UColor.ardoise)
                    }
                    .foregroundStyle(UColor.bleuSignature)
                    .uCard()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(product.resolvedCategory == .nouveaute ? "Pourquoi c'est intéressant" : "Pourquoi c'est en vogue")
                        .font(UFont.body(14, weight: .semibold))
                    Text(product.why)
                        .font(UFont.body(14))
                        .foregroundStyle(UColor.ardoise)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .uCard()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Idée rayon")
                        .font(UFont.body(14, weight: .semibold))
                    Text(product.rayonTip)
                        .font(UFont.body(14))
                        .foregroundStyle(UColor.ardoise)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .uCard()

                VStack(alignment: .leading, spacing: 8) {
                    Text(product.resolvedCategory == .nouveaute ? "Repères" : "Plateformes")
                        .font(UFont.body(14, weight: .semibold))
                    FlowPlatforms(platforms: product.platforms)
                    if !product.tags.isEmpty {
                        Text(product.tags.map { "#\($0)" }.joined(separator: "  "))
                            .font(UFont.body(12, weight: .medium))
                            .foregroundStyle(UColor.bleuSignature)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .uCard()

                if !product.sources.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Sources web")
                            .font(UFont.body(14, weight: .semibold))
                        ForEach(product.sources) { source in
                            if let url = URL(string: source.url) {
                                Link(destination: url) {
                                    HStack {
                                        Image(systemName: "link")
                                        Text(source.title)
                                            .font(UFont.body(14, weight: .semibold))
                                        Spacer()
                                        Image(systemName: "arrow.up.right")
                                    }
                                    .foregroundStyle(UColor.bleuSignature)
                                }
                            }
                        }
                    }
                    .uCard()
                }
            }
            .padding(18)
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.8)) { appear = true }
        }
    }

    private func heroGradient(_ product: TrendingProduct) -> some View {
        LinearGradient(
            colors: [product.rayon.tint, product.rayon.tint.opacity(0.7), UColor.bleuSignature],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct FlowPlatforms: View {
    var platforms: [String]
    var body: some View {
        HStack(spacing: 8) {
            ForEach(platforms, id: \.self) { platform in
                Text(platform)
                    .font(UFont.body(12, weight: .bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .foregroundStyle(UColor.rouge)
                    .background(UColor.rouge.opacity(0.1), in: Capsule())
            }
        }
    }
}

#Preview {
    TendancesView()
        .environmentObject(TrendFeedService())
}
