import SwiftUI

struct SplashView: View {
    @State private var appear = false
    @State private var pulse = false

    var body: some View {
        ZStack {
            UColor.headerGradient.ignoresSafeArea()

            Circle()
                .fill(.white.opacity(0.08))
                .frame(width: 320)
                .scaleEffect(pulse ? 1.12 : 0.88)
                .blur(radius: 8)

            VStack(spacing: 18) {
                ULogoMark(size: 92)
                    .scaleEffect(appear ? 1 : 0.6)
                    .opacity(appear ? 1 : 0)

                VStack(spacing: 6) {
                    Text("U Frais")
                        .font(UFont.display(42))
                        .foregroundStyle(.white)
                    Text(StoreIdentity.name)
                        .font(UFont.body(16, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.88))
                    Text("Calculateur & tendances frais")
                        .font(UFont.body(14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                }
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 16)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.72)) {
                appear = true
            }
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

struct ULogoMark: View {
    var size: CGFloat = 44
    var light: Bool = true

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                .fill(light ? .white : UColor.rouge)
                .shadow(color: .black.opacity(light ? 0.08 : 0.18), radius: 10, y: 4)

            Text("U")
                .font(.system(size: size * 0.58, weight: .heavy, design: .rounded))
                .foregroundStyle(light ? UColor.rouge : .white)
                .offset(y: -size * 0.04)

            Circle()
                .fill(UColor.vertEau)
                .frame(width: size * 0.16, height: size * 0.16)
                .offset(x: size * 0.22, y: size * 0.22)
        }
        .frame(width: size, height: size)
        .accessibilityLabel("U Frais")
    }
}

struct LiveBadge: View {
    var isLive: Bool
    @State private var pulse = false

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(isLive ? Color.green : UColor.ardoise)
                .frame(width: 8, height: 8)
                .scaleEffect(pulse && isLive ? 1.35 : 1)
                .opacity(pulse && isLive ? 0.55 : 1)
            Text(isLive ? "Temps réel" : "En pause")
                .font(UFont.body(12, weight: .semibold))
        }
        .foregroundStyle(isLive ? UColor.bleuSignature : UColor.ardoise)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.white.opacity(0.92), in: Capsule())
        .onAppear {
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

struct KPIStat: View {
    var title: String
    var value: String
    var caption: String
    var symbol: String
    var tint: Color
    var delay: Double = 0

    @State private var shown = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: symbol)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(tint)
                    .frame(width: 30, height: 30)
                    .background(tint.opacity(0.14), in: RoundedRectangle(cornerRadius: 9, style: .continuous))
                Spacer()
            }
            Text(value)
                .font(UFont.display(22))
                .foregroundStyle(UColor.encre)
                .contentTransition(.numericText())
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(UFont.body(13, weight: .semibold))
                    .foregroundStyle(UColor.encre)
                Text(caption)
                    .font(UFont.body(11, weight: .medium))
                    .foregroundStyle(UColor.ardoise)
            }
        }
        .uCard()
        .opacity(shown ? 1 : 0)
        .offset(y: shown ? 0 : 18)
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.78).delay(delay)) {
                shown = true
            }
        }
    }
}

struct RayonChip: View {
    var rayon: RayonKind
    var selected: Bool

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: rayon.symbol)
            Text(rayon.title)
        }
        .font(UFont.body(13, weight: .semibold))
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .foregroundStyle(selected ? .white : rayon.tint)
        .background(
            Capsule().fill(selected ? rayon.tint : rayon.tint.opacity(0.12))
        )
    }
}

struct Sparkline: View {
    var values: [Double]
    var tint: Color = UColor.bleuSignature

    var body: some View {
        GeometryReader { geo in
            let maxV = max(values.max() ?? 1, 1)
            let minV = min(values.min() ?? 0, maxV)
            let span = max(maxV - minV, 1)
            Path { path in
                for (index, value) in values.enumerated() {
                    let x = geo.size.width * CGFloat(index) / CGFloat(max(values.count - 1, 1))
                    let y = geo.size.height * (1 - CGFloat((value - minV) / span))
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(tint, style: StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round))
        }
        .accessibilityHidden(true)
    }
}

struct MarqueGauge: View {
    var value: Double
    var body: some View {
        let clamped = min(max(value, 0), 0.7)
        TimelineView(.animation(minimumInterval: 1 / 30, paused: false)) { context in
            let t = context.date.timeIntervalSinceReferenceDate
            let wave = 0.5 + 0.5 * sin(t * 2)
            ZStack {
                Circle().stroke(UColor.ligne, lineWidth: 8)
                Circle()
                    .trim(from: 0, to: clamped / 0.7)
                    .stroke(
                        AngularGradient(
                            colors: [UColor.rouge, UColor.bleuSignature, UColor.vertEau],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(color: UColor.bleuSignature.opacity(0.25 + 0.15 * wave), radius: 6)
                VStack(spacing: 0) {
                    Text(value.percentFR)
                        .font(UFont.display(16))
                    Text("marque")
                        .font(UFont.body(10, weight: .medium))
                        .foregroundStyle(UColor.ardoise)
                }
            }
        }
    }
}

struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay {
                LinearGradient(
                    colors: [.clear, .white.opacity(0.45), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(12))
                .offset(x: phase * 180)
            }
            .clipped()
            .onAppear {
                withAnimation(.linear(duration: 1.6).repeatForever(autoreverses: false)) {
                    phase = 1.2
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(Shimmer())
    }
}

struct DecimalField: View {
    var title: String
    var suffix: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(UFont.body(13, weight: .semibold))
                .foregroundStyle(UColor.ardoise)
            HStack {
                TextField("0,00", text: $text)
                    .keyboardType(.decimalPad)
                    .font(UFont.display(28, weight: .semibold))
                    .foregroundStyle(UColor.encre)
                Text(suffix)
                    .font(UFont.body(16, weight: .semibold))
                    .foregroundStyle(UColor.bleuSignature)
            }
            .padding(14)
            .background(UColor.creme, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}
