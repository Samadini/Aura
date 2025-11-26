import SwiftUI

// MARK: - Main Splash View

struct AuraSplashView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                Color(red: 0.97, green: 0.95, blue: 0.90) // ~ #F7F1E6
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    LogoCircleView()
                        // Size relative to screen width
                        .frame(width: min(geo.size.width * 0.55, 260),
                               height: min(geo.size.width * 0.55, 260))
                        .shadow(color: Color.black.opacity(0.08),
                                radius: 18, x: 0, y: 10)

                    Spacer()
                }
            }
        }
    }
}

// MARK: - Circular Logo

struct LogoCircleView: View {
    var body: some View {
        ZStack {
            // Base circle mask
            Circle()
                .fill(Color.clear)
                .overlay(
                    ZStack {
                        // Bottom beige wavy area
                        WavyBottomShape()
                            .fill(Color(red: 0.85, green: 0.69, blue: 0.49)) // ~ #D9B07C

                        // Top green wavy area
                        WavyTopShape()
                            .fill(Color(red: 0.55, green: 0.69, blue: 0.48)) // ~ #8DAF7A
                    }
                )
                .clipShape(Circle())

            // "Aura" text overlay
            Text("Aura")
                .font(.system(size: 64, weight: .regular, design: .serif))
                .kerning(1.5)
                .foregroundColor(Color(red: 0.09, green: 0.21, blue: 0.15)) // ~ #173526
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(.horizontal, 16)
        }
    }
}

// MARK: - Wavy Shapes

/// Upper green area with a smooth lower edge
struct WavyTopShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height

        // Start at top-left
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))

        // Right edge down
        path.addLine(to: CGPoint(x: width, y: height * 0.42))

        // Wavy curve from right to left (lower edge of green)
        path.addCurve(
            to: CGPoint(x: 0, y: height * 0.50),
            control1: CGPoint(x: width * 0.72, y: height * 0.30),
            control2: CGPoint(x: width * 0.30, y: height * 0.65)
        )

        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()

        return path
    }
}

/// Lower beige area with a smooth upper edge
struct WavyBottomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height

        // Start at bottom-left
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))

        // Right edge up
        path.addLine(to: CGPoint(x: width, y: height * 0.60))

        // Wavy curve from right to left (upper edge of beige)
        path.addCurve(
            to: CGPoint(x: 0, y: height * 0.68),
            control1: CGPoint(x: width * 0.78, y: height * 0.45),
            control2: CGPoint(x: width * 0.30, y: height * 0.90)
        )

        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()

        return path
    }
}

// MARK: - Preview

struct AuraSplashView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuraSplashView()
                .preferredColorScheme(.light)

            AuraSplashView()
                .preferredColorScheme(.dark)
        }
    }
}
