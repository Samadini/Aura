import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Profile Header
                        VStack(spacing: 8) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray.opacity(0.3))
                                .clipShape(Circle())
                            
                            Text("Sama")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            HStack {
                                Text("Beauty Lover")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Image(systemName: "sparkles")
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding(.top, 40)
                        
                        // Menu Section 1
                        VStack(alignment: .leading, spacing: 0) {
                            ProfileMenuItem(icon: "person.fill", text: "Edit Profile", color: .green)
                            Divider().padding(.leading, 60)
                            ProfileMenuItem(icon: "archivebox.fill", text: "Order History", color: .orange)
                            Divider().padding(.leading, 60)
                            ProfileMenuItem(icon: "heart.fill", text: "Wishlist", color: .pink)
                            Divider().padding(.leading, 60)
                            ProfileMenuItem(icon: "brain.head.profile", text: "Shade Match Results", color: .purple)
                            Divider().padding(.leading, 60)
                            ProfileMenuItem(icon: "camera.viewfinder", text: "AR Try-On History", color: .blue)
                            Divider().padding(.leading, 60)
                            ProfileMenuItem(icon: "creditcard.fill", text: "Payment Methods", color: .yellow)
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        // Menu Section 2
                        VStack(alignment: .leading, spacing: 0) {
                            ProfileMenuItem(icon: "gearshape.fill", text: "Settings", color: .gray)
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                
                Text(text)
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.4))
            }
            .padding()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
