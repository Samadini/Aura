import SwiftUI

// MARK: - Wishlist Item Model
struct WishlistItem: Identifiable {
    let id = UUID()
    let brand: String
    let name: String
    let price: String
    let imageName: String
}

// MARK: - Main Wishlist View
struct WishlistView: View {
    // Sample Data
    let items = [
        WishlistItem(brand: "Aura Beauty", name: "Velvet Matte Lipstick", price: "$24.00", imageName: "lipstick"),
        WishlistItem(brand: "Aura Skincare", name: "Hydrating Serum", price: "$38.00", imageName: "serum"),
        WishlistItem(brand: "Aura Beauty", name: "Glow Foundation", price: "$42.00", imageName: "foundation")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Image(systemName: "arrow.left")
                    Spacer()
                    Text("Wishlist").font(.headline)
                    Spacer()
                }
                .padding()
                
                // Wishlist Items
                List(items) {
                    WishlistItemRow(item: $0)
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Wishlist Item Row View
struct WishlistItemRow: View {
    let item: WishlistItem
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo") // Placeholder for product image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.brand)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(item.name)
                    .font(.headline)
                Text(item.price)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Add to Cart") {
                // Add to cart action
            }
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(red: 0.85, green: 0.6, blue: 0.6))
            .foregroundColor(.white)
            .cornerRadius(16)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(20)
    }
}

// MARK: - Preview
struct WishlistView_Previews: PreviewProvider {
    static var previews: some View {
        WishlistView()
    }
}
