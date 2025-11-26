import SwiftUI

struct OnboardingView: View {
    var onGetStarted: () -> Void // Callback
    var body: some View {
        ZStack {
            // Background Color
            Color(red: 0.97, green: 0.95, blue: 0.90) // ~ #F7F1E6
                .ignoresSafeArea()

            // Decorative image circles
            ProductCircle(imageName: "eyedropper", backgroundColor: Color(red: 0.95, green: 0.84, blue: 0.73))
                .offset(x: 120, y: -320)

            ProductCircle(imageName: "circle.grid.3x3.fill", backgroundColor: Color(red: 0.85, green: 0.91, blue: 0.84))
                .offset(x: -150, y: -350)
            
            ProductCircle(imageName: "shippingbox.fill", backgroundColor: Color(red: 0.85, green: 0.91, blue: 0.84))
                .offset(x: 140, y: 280)
            
            ProductCircle(imageName: "gift.fill", backgroundColor: Color(red: 0.95, green: 0.84, blue: 0.73))
                .offset(x: -130, y: 150)

            VStack(spacing: 20) {
                Spacer()

                // Main Text
                Text("Your Skin,\nBreathe")
                    .font(.system(size: 56, weight: .regular, design: .serif))
                    .foregroundColor(Color(red: 0.2, green: 0.18, blue: 0.15))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)

                Spacer()
                Spacer()

                // Get Started Button
                Button(action: {
                    onGetStarted()
                }) {
                    Text("Get Started")
                        .font(.system(.headline, design: .serif))
                        .foregroundColor(Color(red: 0.97, green: 0.95, blue: 0.90))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.79, green: 0.66, blue: 0.57)) // ~ #C9A892
                        .cornerRadius(25)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// Helper view for the decorative circles
struct ProductCircle: View {
    let imageName: String
    let backgroundColor: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: 150, height: 150)
            
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onGetStarted: {})
    }
}
