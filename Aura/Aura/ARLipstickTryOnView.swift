import SwiftUI
import ARKit
import RealityKit

// This screen should be opened from the lipstick ProductDetailView when the user taps “Try in AR”.

// MARK: - Data Model

struct LipstickShade: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let color: Color
}

// MARK: - Main View

struct ARLipstickTryOnView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Sample Data
    let shades: [LipstickShade] = [
        LipstickShade(name: "Peach Nude", color: Color(red: 0.9, green: 0.6, blue: 0.5)),
        LipstickShade(name: "Coral Kiss", color: Color(red: 1.0, green: 0.5, blue: 0.4)),
        LipstickShade(name: "Deep Berry", color: Color(red: 0.6, green: 0.1, blue: 0.3)),
        LipstickShade(name: "Rose Petal", color: Color(red: 0.85, green: 0.4, blue: 0.5)),
        LipstickShade(name: "Ruby Red", color: Color(red: 0.8, green: 0.1, blue: 0.2)),
        LipstickShade(name: "Spiced Plum", color: Color(red: 0.5, green: 0.2, blue: 0.3))
    ]
    
    @State private var selectedShade: LipstickShade? = nil
    
    // Accent Color
    let accentColor = Color(red: 0.74, green: 0.88, blue: 0.78)
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // AR View
                ARLipstickViewRepresentable(selectedShade: $selectedShade)
                    .edgesIgnoringSafeArea(.all)
                
                // Gradient Overlay
                VStack {
                    Spacer()
                    LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.6)]),
                                   startPoint: .top, endPoint: .bottom)
                        .frame(height: 300)
                }
                .edgesIgnoringSafeArea(.all)
                
                // Bottom Panel
                VStack(spacing: 20) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(shades) { shade in
                                ShadeSelector(shade: shade, selectedShade: $selectedShade)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(spacing: 12) {
                        Button(action: { /* Navigate to Product Detail */ }) {
                            Text("View Product")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(accentColor)
                                .foregroundColor(.black)
                                .cornerRadius(12)
                        }
                        
                        Button(action: { /* Add to Wishlist */ }) {
                            Text("Add to Wishlist")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .navigationBarTitle("AR Try-On", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.primary)
            })
        }
    }
}

// MARK: - Helper Views

struct ShadeSelector: View {
    let shade: LipstickShade
    @Binding var selectedShade: LipstickShade?
    
    var isSelected: Bool {
        selectedShade == shade
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(shade.color)
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(isSelected ? .white : .clear, lineWidth: 3)
                )
                .shadow(radius: isSelected ? 5 : 2)
            
            Text(shade.name)
                .font(.caption)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(.white)
        }
        .onTapGesture {
            withAnimation(.spring()) {
                selectedShade = shade
            }
        }
    }
}

// MARK: - AR Integration

struct ARLipstickViewRepresentable: UIViewRepresentable {
    @Binding var selectedShade: LipstickShade?

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        guard ARFaceTrackingConfiguration.isSupported else {
            print("Face tracking is not supported on this device.")
            return arView
        }
        
        let configuration = ARFaceTrackingConfiguration()
        arView.session.run(configuration)
        arView.session.delegate = context.coordinator
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        guard let shade = selectedShade else { return }
        context.coordinator.applyShadeToLips(shade: shade, in: uiView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, ARSessionDelegate {
        var faceAnchor: ARFaceAnchor? = nil
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            guard let faceAnchor = anchors.compactMap({ $0 as? ARFaceAnchor }).first else { return }
            self.faceAnchor = faceAnchor
        }
        
        func applyShadeToLips(shade: LipstickShade, in arView: ARView) {
            // TODO: Implement AR lip-mapping logic here.
            // 1. Get the ARFaceAnchor from the session delegate.
            // 2. Access the face geometry (ARFaceGeometry) and find the vertices corresponding to the lips.
            // 3. Create a custom RealityKit material with the selected shade's color.
            // 4. Create a mesh from the lip vertices and apply the material.
            // 5. Add the lip mesh entity to the face anchor in the AR scene.
            print("Applying shade: \(shade.name)")
        }
    }
}

// MARK: - Example Navigation

struct ProductDetailViewExample: View {
    @State private var isShowingARTryOn = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Lipstick Product Page")
                .font(.largeTitle)
            
            Button("Try in AR") {
                isShowingARTryOn.toggle()
            }
            .sheet(isPresented: $isShowingARTryOn) {
                ARLipstickTryOnView()
            }
        }
    }
}

// MARK: - Preview

struct ARLipstickTryOnView_Previews: PreviewProvider {
    static var previews: some View {
        ARLipstickTryOnView()
    }
}
