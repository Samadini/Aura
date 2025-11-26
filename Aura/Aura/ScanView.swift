import SwiftUI
import ARKit
import RealityKit
import SceneKit
import UIKit

struct ScanView: View {
    
    @Binding var selectedTab: Int
    
    let recommendedShades = [
        Shade(name: "Cashmere Beige", code: "3N1", imageURL: "https://images.unsplash.com/photo-1611779922936-0c8472a42a26?q=80&w=2187&auto=format&fit=crop"),
        Shade(name: "Warm Nude", code: "4W2", imageURL: "https://images.unsplash.com/photo-1620463055101-735392c25758?q=80&w=2187&auto=format&fit=crop"),
        Shade(name: "Golden Sand", code: "5N1", imageURL: "https://images.unsplash.com/photo-1599387737838-66a352358506?q=80&w=2187&auto=format&fit=crop"),
        Shade(name: "Ivory", code: "2N0", imageURL: "https://images.unsplash.com/photo-1544006659-f0b21884ce1d?q=80&w=1920&auto=format&fit=crop"),
        Shade(name: "Porcelain", code: "1N0", imageURL: "https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?q=80&w=1920&auto=format&fit=crop"),
        Shade(name: "Honey", code: "4N2", imageURL: "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=1920&auto=format&fit=crop"),
        Shade(name: "Caramel", code: "6W1", imageURL: "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=1920&auto=format&fit=crop"),
        Shade(name: "Mocha", code: "7N1", imageURL: "https://images.unsplash.com/photo-1544717305-2782549b5136?q=80&w=1920&auto=format&fit=crop")
    ]
    
    @State private var isARActive = false
    @State private var arSupported = ARFaceTrackingConfiguration.isSupported
    @State private var cameraStatus: String = "Starting camera..."
    @State private var lightIntensity: CGFloat? = nil
    @State private var selectedShadeIndex: Int = 0
    @State private var intensity: Double = 0.6
    @State private var showTint: Bool = true
    @State private var detectedUndertone: String = "Scanning your undertone..."
    @State private var detectedShadeRange: String = ""
    @State private var finishSuggestion: String = ""
    @State private var showMenuSheet: Bool = false
    @State private var showCameraAlert: Bool = false
    @Environment(\.scenePhase) private var scenePhase

    private func updateMaskOpacity(_ value: Double) {
        intensity = max(0.0, min(1.0, value))
    }

    private func applyFoundationTone(_ index: Int, opacity: Double? = nil) {
        selectedShadeIndex = index
        if let opacity = opacity {
            updateMaskOpacity(opacity)
        }
    }

    var body: some View {
        ZStack {
            // Background AR feed
            if arSupported {
                // Opacity is driven directly from the slider (0.0–1.0) and tint toggle
                let opacity = showTint ? intensity : 0.0

                ARFaceScanView(
                    isRunning: isARActive,
                    lightIntensity: $lightIntensity,
                    tintColor: UIColor(Color(hex: shadeColorHex(recommendedShades[selectedShadeIndex].code))),
                    tintAlpha: CGFloat(opacity)
                )
                .ignoresSafeArea()
                .onAppear {
                    isARActive = true
                    cameraStatus = "Align your face in the frame"
                }
                .onDisappear {
                    isARActive = false
                    cameraStatus = ""
                }
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    if newPhase == .inactive || newPhase == .background {
                        isARActive = false
                    } else if newPhase == .active {
                        isARActive = true
                    }
                }
            } else {
                Color.black.ignoresSafeArea()
                Text("This device does not support AR face tracking.")
                    .foregroundColor(.white)
                    .padding()
            }

            // UI overlays
            VStack {
                // Top bar
                HStack(spacing: 16) {
                    CircleIconButton(systemName: "xmark") {
                        // Go back to Home tab when closing from Scan
                        selectedTab = 0
                    }
                    Spacer()
                    CircleIconButton(systemName: "line.3.horizontal") {
                        showMenuSheet = true
                    }
                    CircleIconButton(systemName: "arrow.triangle.2.circlepath.camera") {
                        showCameraAlert = true
                    }
                    CircleIconButton(systemName: "gobackward") {
                        // Reset tracking by restarting the session and clearing scan results
                        isARActive = false
                        lightIntensity = nil
                        detectedUndertone = "Scanning your undertone..."
                        detectedShadeRange = ""
                        finishSuggestion = ""
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isARActive = true
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .sheet(isPresented: $showMenuSheet) {
                    NavigationView {
                        List {
                            Section(header: Text("Scan Options")) {
                                Button("Reset Scan") {
                                    isARActive = false
                                    lightIntensity = nil
                                    detectedUndertone = "Scanning your undertone..."
                                    detectedShadeRange = ""
                                    finishSuggestion = ""
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        isARActive = true
                                    }
                                }
                                Button("Close Scanner") {
                                    // Also go back to Home tab when closing from menu
                                    selectedTab = 0
                                }
                            }
                        }
                        .navigationTitle("Scan Menu")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
                .alert("Camera Flip Not Available", isPresented: $showCameraAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("AR face tracking only works with the front camera on this device.")
                }

                Spacer()

                // Center title
                VStack(spacing: 6) {
                    Text(recommendedShades[selectedShadeIndex].name)
                        .font(.title3).bold()
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                }
                .padding(.bottom, 12)
                
                // Scan result info panel
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your scan result")
                        .font(.caption).bold()
                        .foregroundColor(.white.opacity(0.9))

                    Text("Undertone: \(detectedUndertone)")
                        .font(.caption2)
                        .foregroundColor(.white)

                    if !detectedShadeRange.isEmpty {
                        Text("Suggested shade range: \(detectedShadeRange)")
                            .font(.caption2)
                            .foregroundColor(.white)
                    }

                    if !finishSuggestion.isEmpty {
                        Text("Best finish: \(finishSuggestion)")
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                }
                .padding(10)
                .background(Color.black.opacity(0.35))
                .cornerRadius(10)
                .padding(.horizontal, 24)
                
                // Tint toggle
                Toggle(isOn: $showTint) {
                    Text("Show Tint")
                        .foregroundColor(.white)
                        .font(.footnote)
                }
                .tint(.white)
                .padding(.horizontal, 24)

                // Intensity slider row
                HStack(alignment: .center, spacing: 14) {
                    Image(systemName: "drop.fill").foregroundColor(.white.opacity(0.9))
                    Slider(
                        value: Binding(
                            get: { intensity },
                            set: { newValue in
                                updateMaskOpacity(newValue)
                            }
                        ),
                        in: 0...1,
                        step: 0.01
                    )
                        .tint(.white)
                    Text("\(Int(intensity * 100))% Opacity")
                        .foregroundColor(.white)
                        .font(.footnote)
                        .frame(width: 100, alignment: .trailing)
                }
                .padding(.horizontal, 24)

                // Action row (share, selected color, bag)
                HStack(spacing: 28) {
                    CircleIconButton(systemName: "square.and.arrow.up") {
                        // Share action
                    }

                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 70, height: 70)
                        Circle()
                            .fill(Color(hex: shadeColorHex(recommendedShades[selectedShadeIndex].code)))
                            .frame(width: 54, height: 54)
                            .overlay(Circle().stroke(Color.white.opacity(0.9), lineWidth: 2))
                    }

                    CircleIconButton(systemName: "bag") {
                        // Add to bag action
                    }
                }
                .padding(.vertical, 8)

                // Swatches
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(recommendedShades.indices, id: \.self) { idx in
                            let isSelected = idx == selectedShadeIndex
                            Circle()
                                .fill(Color(hex: shadeColorHex(recommendedShades[idx].code)))
                                .frame(width: isSelected ? 44 : 36, height: isSelected ? 44 : 36)
                                .overlay(
                                    Circle().stroke(Color.white.opacity(isSelected ? 1 : 0.6), lineWidth: isSelected ? 3 : 1)
                                )
                                .onTapGesture {
                                    applyFoundationTone(idx)
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
        }
    }
}

struct CircleIconButton: View {
    let systemName: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(Color.black.opacity(0.35))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") { hexSanitized.removeFirst() }
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

private func shadeColorHex(_ code: String) -> String {
    // Simple mapping for demo purposes. Map shade codes to representative colors.
    switch code.uppercased() {
    case "1N0": return "#F7E6D8"   // Porcelain
    case "2N0": return "#F2D8C4"   // Ivory
    case "3N1": return "#F1C7B1"   // Cashmere Beige
    case "4W2": return "#E0A389"   // Warm Nude (warmer)
    case "4N2": return "#D6A27E"   // Honey
    case "5N1": return "#B87A5A"   // Golden Sand
    case "6W1": return "#996247"   // Caramel
    case "7N1": return "#7A4D39"   // Mocha
    default: return "#D8B4A6"
    }
}

// MARK: - ARKit Face Scan View

struct ARFaceScanView: UIViewRepresentable {
    var isRunning: Bool
    @Binding var lightIntensity: CGFloat?
    var tintColor: UIColor
    var tintAlpha: CGFloat
    
    func makeUIView(context: Context) -> ARSCNView {
        let view = ARSCNView(frame: .zero)
        view.delegate = context.coordinator
        view.automaticallyUpdatesLighting = true
        view.scene = SCNScene()
        return view
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        
        if isRunning {
            if uiView.session.configuration == nil {
                let configuration = ARFaceTrackingConfiguration()
                configuration.isLightEstimationEnabled = true
                uiView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            }
        } else {
            if uiView.session.configuration != nil {
                uiView.session.pause()
            }
        }
        // Push latest tint to coordinator so material updates even without new anchors
        context.coordinator.currentTintColor = tintColor
        context.coordinator.currentTintAlpha = tintAlpha
        context.coordinator.refreshMaterialIfNeeded()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARFaceScanView
        private var faceNode: SCNNode?
        private var faceGeometry: ARSCNFaceGeometry?

        var currentTintColor: UIColor = .clear
        var currentTintAlpha: CGFloat = 0.0

        init(parent: ARFaceScanView) {
            self.parent = parent
        }

        func refreshMaterialIfNeeded() {
            guard let geometry = self.faceGeometry, let material = geometry.firstMaterial else { return }
            material.diffuse.contents = currentTintColor
            material.transparency = max(0.0, min(1.0, currentTintAlpha))
            material.roughness.contents = NSNumber(value: Float(0.45 - 0.15 * currentTintAlpha))
            material.blendMode = .alpha
            if let maskImage = UIImage(named: "FaceMaskAlpha") {
                material.transparent.contents = maskImage
            }
        }

        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            guard let device = (renderer as? ARSCNView)?.device,
                  anchor is ARFaceAnchor else { return nil }

            let geometry = ARSCNFaceGeometry(device: device)!
            let material = geometry.firstMaterial!
            material.lightingModel = .physicallyBased
            material.diffuse.contents = parent.tintColor
            material.transparency = max(0.0, min(1.0, parent.tintAlpha))
            material.roughness.contents = NSNumber(value: Float(0.45 - 0.15 * parent.tintAlpha))
            material.metalness.contents = 0.0
            material.blendMode = .alpha
            if let maskImage = UIImage(named: "FaceMaskAlpha") {
                material.transparent.contents = maskImage
            }
            material.writesToDepthBuffer = false
            material.readsFromDepthBuffer = false

            let node = SCNNode(geometry: geometry)
            node.renderingOrder = -1

            self.currentTintColor = parent.tintColor
            self.currentTintAlpha = parent.tintAlpha

            self.faceNode = node
            self.faceGeometry = geometry
            return node
        }

        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let faceAnchor = anchor as? ARFaceAnchor,
                  let geometry = self.faceGeometry else { return }
            geometry.update(from: faceAnchor.geometry)

            // Update material with current tint values
            refreshMaterialIfNeeded()
        }

        // Existing logging callbacks
        func session(_ session: ARSession, didFailWithError error: Error) { print("AR session failed: \(error.localizedDescription)") }
        func sessionWasInterrupted(_ session: ARSession) { print("AR session was interrupted") }
        func sessionInterruptionEnded(_ session: ARSession) { print("AR session interruption ended") }
    }
}

struct Shade: Identifiable {
    let id = UUID()
    let name: String
    let code: String
    let imageURL: String
}

struct ShadeCard: View {
    let shade: Shade
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: shade.imageURL)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 180)
                    .clipped()
            } placeholder: {
                Color.gray.opacity(0.1)
                    .frame(width: 180, height: 180)
            }
            .cornerRadius(12)
            
            Text(shade.name).font(.headline)
            Text(shade.code).font(.subheadline).foregroundColor(.gray)
            
            Button(action: {}) {
                Text("Add to Bag")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView(selectedTab: .constant(2))
    }
}

