import SwiftUI

@main
struct UFraisApp: App {
    @StateObject private var trends = TrendFeedService()
    @StateObject private var history = HistoryStore()
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(trends)
                    .environmentObject(history)

                if showSplash {
                    SplashView()
                        .transition(.asymmetric(
                            insertion: .opacity,
                            removal: .scale(scale: 1.06).combined(with: .opacity)
                        ))
                        .zIndex(1)
                }
            }
            .preferredColorScheme(.light)
            .task {
                try? await Task.sleep(for: .milliseconds(1700))
                withAnimation(.easeInOut(duration: 0.55)) {
                    showSplash = false
                }
            }
        }
    }
}
