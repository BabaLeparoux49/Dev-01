import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case calcul, concurrent, tendances

    var id: String { rawValue }

    var title: String {
        switch self {
        case .calcul: return "Calcul"
        case .concurrent: return "Scan"
        case .tendances: return "Tendances"
        }
    }

    var symbol: String {
        switch self {
        case .calcul: return "plusminus.circle.fill"
        case .concurrent: return "barcode.viewfinder"
        case .tendances: return "flame.fill"
        }
    }
}

struct ContentView: View {
    @State private var tab: AppTab = .calcul
    @Namespace private var tabNS

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch tab {
                case .calcul: CalculatorView()
                case .concurrent: ConcurrentView()
                case .tendances: TendancesView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            customTabBar
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(UColor.creme.ignoresSafeArea())
    }

    private var customTabBar: some View {
        HStack(spacing: 6) {
            ForEach(AppTab.allCases) { item in
                Button {
                    withAnimation(.spring(response: 0.38, dampingFraction: 0.78)) {
                        tab = item
                    }
                } label: {
                    VStack(spacing: 4) {
                        ZStack {
                            if tab == item {
                                Capsule()
                                    .fill(UColor.rouge)
                                    .matchedGeometryEffect(id: "tab", in: tabNS)
                                    .frame(width: 42, height: 32)
                            }
                            Image(systemName: item.symbol)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(tab == item ? .white : UColor.ardoise)
                                .symbolEffect(.bounce, value: tab == item)
                        }
                        .frame(height: 32)
                        Text(item.title)
                            .font(UFont.body(10, weight: .bold))
                            .foregroundStyle(tab == item ? UColor.rouge : UColor.ardoise)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: tab)
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 6)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(UColor.ligne)
                .frame(height: 0.8)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TrendFeedService())
        .environmentObject(HistoryStore())
}
