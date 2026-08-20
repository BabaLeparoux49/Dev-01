import SwiftUI

/// Couleurs issues de la charte Coopérative U
/// (rouge historique, bleu signature, bleu ciel, vert d'eau).
enum UColor {
    static let rouge = Color(red: 226 / 255, green: 32 / 255, blue: 25 / 255)
    static let rougeFonce = Color(red: 176 / 255, green: 18 / 255, blue: 16 / 255)
    static let bleuSignature = Color(red: 0 / 255, green: 125 / 255, blue: 143 / 255)
    static let bleuCiel = Color(red: 100 / 255, green: 197 / 255, blue: 228 / 255)
    static let vertEau = Color(red: 107 / 255, green: 191 / 255, blue: 182 / 255)
    static let creme = Color(red: 246 / 255, green: 248 / 255, blue: 249 / 255)
    static let ivoire = Color(red: 255 / 255, green: 252 / 255, blue: 248 / 255)
    static let encre = Color(red: 28 / 255, green: 32 / 255, blue: 36 / 255)
    static let ardoise = Color(red: 90 / 255, green: 102 / 255, blue: 110 / 255)
    static let ligne = Color(red: 226 / 255, green: 232 / 255, blue: 236 / 255)

    static let fondGradient = LinearGradient(
        colors: [
            Color(red: 0.97, green: 0.98, blue: 0.99),
            Color(red: 0.93, green: 0.96, blue: 0.97)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let headerGradient = LinearGradient(
        colors: [rouge, rougeFonce, bleuSignature],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let liveGradient = LinearGradient(
        colors: [bleuSignature, vertEau],
        startPoint: .leading,
        endPoint: .trailing
    )
}

enum UFont {
    static func display(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func body(_ size: CGFloat = 16, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

extension Double {
    var euros: String {
        formatted(.currency(code: "EUR").locale(Locale(identifier: "fr_FR")))
    }

    var eurosCompact: String {
        formatted(.currency(code: "EUR").locale(Locale(identifier: "fr_FR")).precision(.fractionLength(2)))
    }

    var percentFR: String {
        formatted(.percent.locale(Locale(identifier: "fr_FR")).precision(.fractionLength(1)))
    }

    var numberFR: String {
        formatted(.number.locale(Locale(identifier: "fr_FR")).precision(.fractionLength(2)))
    }
}

extension View {
    func uCard(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.white)
                    .shadow(color: UColor.bleuSignature.opacity(0.08), radius: 18, y: 8)
            )
    }

    func uSurface() -> some View {
        self.background(UColor.fondGradient.ignoresSafeArea())
    }
}
