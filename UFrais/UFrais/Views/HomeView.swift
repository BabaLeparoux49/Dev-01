import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var feed: LiveFeedService
    @State private var appear = false
    @State private var showIdentity = false

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: .now)
        switch hour {
        case 5..<12: return "Bonjour"
        case 12..<18: return "Bon après-midi"
        default: return "Bonsoir"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                    kpiGrid
                    liveStrip
                    topVA
                    rayonHealth
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 28)
            }
            .uSurface()
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showIdentity) {
                MagasinSheet()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(UColor.headerGradient)
                .overlay(alignment: .topTrailing) {
                    Circle()
                        .fill(.white.opacity(0.1))
                        .frame(width: 180)
                        .offset(x: 40, y: -50)
                }
                .overlay(alignment: .bottomTrailing) {
                    Circle()
                        .fill(UColor.vertEau.opacity(0.22))
                        .frame(width: 120)
                        .offset(x: 20, y: 30)
                }

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    ULogoMark(size: 46)
                    Spacer()
                    LiveBadge(isLive: feed.isLive)
                    Button {
                        showIdentity = true
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.white.opacity(0.92))
                    }
                    .accessibilityLabel("Infos magasin")
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(greeting) \(StoreIdentity.userFirstName)")
                        .font(UFont.display(28))
                        .foregroundStyle(.white)
                    Text(StoreIdentity.role)
                        .font(UFont.body(14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.82))
                    Text("\(StoreIdentity.name) · \(StoreIdentity.postalCode)")
                        .font(UFont.body(13, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            .padding(22)
        }
        .frame(height: 210)
        .padding(.top, 8)
        .scaleEffect(appear ? 1 : 0.96)
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.78)) {
                appear = true
            }
        }
    }

    private var kpiGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            KPIStat(
                title: "CA frais",
                value: feed.caJour.euros,
                caption: "Ventes du jour TTC",
                symbol: "basket.fill",
                tint: UColor.rouge,
                delay: 0.05
            )
            KPIStat(
                title: "Marge brute",
                value: feed.margeJour.euros,
                caption: "Valeur ajoutée HT",
                symbol: "chart.line.uptrend.xyaxis",
                tint: UColor.bleuSignature,
                delay: 0.12
            )
            KPIStat(
                title: "Marque moyenne",
                value: feed.marqueMoyenne.percentFR,
                caption: "Pondérée par la marge",
                symbol: "percent",
                tint: UColor.vertEau,
                delay: 0.18
            )
            KPIStat(
                title: "Alertes rayon",
                value: "\(feed.alertCount)",
                caption: "Stock ou DLC",
                symbol: "bell.badge.fill",
                tint: Color.orange,
                delay: 0.24
            )
        }
        .animation(.snappy, value: feed.caJour)
    }

    private var liveStrip: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Ne rien louper")
                    .font(UFont.display(18))
                Spacer()
                Text(feed.lastUpdate, style: .timer)
                    .font(UFont.body(12, weight: .semibold))
                    .foregroundStyle(UColor.ardoise)
            }

            if let event = feed.events.first {
                HStack(spacing: 12) {
                    Image(systemName: event.symbol)
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(event.tint, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(event.title)
                            .font(UFont.body(14, weight: .semibold))
                            .foregroundStyle(UColor.encre)
                            .lineLimit(1)
                        Text(event.detail)
                            .font(UFont.body(12))
                            .foregroundStyle(UColor.ardoise)
                            .lineLimit(2)
                    }
                    Spacer(minLength: 0)
                }
                .uCard()
                .shimmer()
                .id(event.id)
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.spring(response: 0.45, dampingFraction: 0.8), value: event.id)
            }
        }
    }

    private var topVA: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Top valeur ajoutée")
                    .font(UFont.display(18))
                Spacer()
                Text("aujourd'hui")
                    .font(UFont.body(12, weight: .semibold))
                    .foregroundStyle(UColor.ardoise)
            }

            ForEach(Array(feed.topVA.prefix(3).enumerated()), id: \.element.id) { index, product in
                NavigationLink {
                    ProductDetailView(productID: product.id)
                } label: {
                    HStack(spacing: 12) {
                        Text("\(index + 1)")
                            .font(UFont.display(18))
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                            .background(index == 0 ? UColor.rouge : UColor.bleuSignature, in: Circle())
                        VStack(alignment: .leading, spacing: 3) {
                            Text(product.name)
                                .font(UFont.body(15, weight: .semibold))
                                .foregroundStyle(UColor.encre)
                            Text("\(product.rayon.title) · \(product.unitsSoldToday) ventes")
                                .font(UFont.body(12))
                                .foregroundStyle(UColor.ardoise)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(product.contributionToday.euros)
                                .font(UFont.body(15, weight: .bold))
                                .foregroundStyle(UColor.bleuSignature)
                                .contentTransition(.numericText())
                            Text(product.breakdown.marqueRate.percentFR)
                                .font(UFont.body(11, weight: .semibold))
                                .foregroundStyle(UColor.vertEau)
                        }
                    }
                    .uCard(padding: 14)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var rayonHealth: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Santé des rayons")
                .font(UFont.display(18))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(feed.snapshots()) { snap in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: snap.kind.symbol)
                                    .foregroundStyle(snap.kind.tint)
                                Text(snap.kind.title)
                                    .font(UFont.body(13, weight: .semibold))
                            }
                            Text(snap.caTTC.euros)
                                .font(UFont.display(16))
                            Text("Marque \(snap.marque.percentFR)")
                                .font(UFont.body(12, weight: .medium))
                                .foregroundStyle(UColor.ardoise)
                            HStack(spacing: 8) {
                                Label("\(snap.ruptures)", systemImage: "shippingbox")
                                Label("\(snap.dlc)", systemImage: "clock")
                            }
                            .font(UFont.body(11, weight: .semibold))
                            .foregroundStyle(snap.ruptures + snap.dlc > 0 ? UColor.rouge : UColor.vertEau)
                        }
                        .padding(14)
                        .frame(width: 168, alignment: .leading)
                        .background(.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: snap.kind.tint.opacity(0.12), radius: 12, y: 6)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

struct MagasinSheet: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ULogoMark(size: 56)
            Text(StoreIdentity.name)
                .font(UFont.display(26))
            Text("\(StoreIdentity.address)\n\(StoreIdentity.postalCode) \(StoreIdentity.city)\n\(StoreIdentity.department)")
                .font(UFont.body(15))
                .foregroundStyle(UColor.ardoise)
            Divider()
            Label(StoreIdentity.role, systemImage: "person.crop.circle.badge.checkmark")
                .font(UFont.body(15, weight: .semibold))
            Text("Les ventes en temps réel sont simulées à partir du catalogue frais du magasin, en attendant une connexion caisse / GPAO.")
                .font(UFont.body(13))
                .foregroundStyle(UColor.ardoise)
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(UColor.creme.ignoresSafeArea())
    }
}

#Preview {
    HomeView()
        .environmentObject(LiveFeedService())
}
