import SwiftUI

struct ShopView: View {
    
    let products = [
        Product(name: "Hydrating Gel Cream", brand: "Aura", price: "$24.99", imageURL: "https://images.unsplash.com/photo-1625708458529-6e675e2857a2?q=80&w=2187&auto=format&fit=crop", rating: 4.7),
        Product(name: "Vitamin C Serum", brand: "Aura", price: "$45.00", imageURL: "https://images.unsplash.com/photo-1608248579934-2376b33411b5?q=80&w=2187&auto=format&fit=crop", rating: 4.9),
        Product(name: "Daily Defense Sunscreen", brand: "Aura", price: "$38.00", imageURL: "https://images.unsplash.com/photo-1599387737838-66a352358506?q=80&w=2187&auto=format&fit=crop", rating: 4.5),
        Product(name: "Gentle Cleansing Oil", brand: "Aura", price: "$50.00", imageURL: "https://images.unsplash.com/photo-1611779922936-0c8472a42a26?q=80&w=2187&auto=format&fit=crop", rating: 4.8),
        Product(name: "Night Repair Cream", brand: "Aura", price: "$78.00", imageURL: "https://images.unsplash.com/photo-1620463055101-735392c25758?q=80&w=2187&auto=format&fit=crop", rating: 4.6),
        Product(name: "Brightening Eye Cream", brand: "Aura", price: "$64.00", imageURL: "https://images.unsplash.com/photo-1556228852-6d45a7ae2673?q=80&w=2080&auto=format&fit=crop", rating: 4.9)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ShopHeader()
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        ForEach(products) { product in
                            ProductTile(product: product)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ShopHeader: View {
    @State private var searchText = ""
    
    let sortOptions = ["Featured", "Newest", "Price: High to Low", "Price: Low to High"]
    @State private var selectedSort = "Sort By"
    
    let brandOptions = ["Aura", "Chroma", "Mirage", "Aether"]
    @State private var selectedBrand = "Brand"
    
    let skinTypeOptions = ["Normal", "Oily", "Dry", "Combination"]
    @State private var selectedSkinType = "Skin Type"

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {}) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Moisturizers")
                    .font(.headline)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.clear)
                }
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search for products...", text: $searchText)
            }
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    FilterMenu(label: $selectedSort, options: sortOptions, isPrimary: true)
                    FilterMenu(label: $selectedBrand, options: brandOptions)
                    FilterMenu(label: $selectedSkinType, options: skinTypeOptions)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct FilterMenu: View {
    @Binding var label: String
    let options: [String]
    var isPrimary = false
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: { label = option }) {
                    Text(option)
                }
            }
        } label: {
            HStack {
                Text(label)
                Image(systemName: "chevron.down")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isPrimary ? Color.red.opacity(0.8) : Color.gray.opacity(0.1))
            .foregroundColor(isPrimary ? .white : .black)
            .cornerRadius(8)
        }
    }
}

struct ProductTile: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: product.imageURL)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
            } placeholder: {
                Color.gray.opacity(0.1)
                    .frame(height: 150)
            }
            .cornerRadius(12)
            
            Text(product.name)
                .font(.headline)
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", product.rating ?? 0.0))
            }
            .font(.subheadline)
            
            Text(product.price)
                .font(.headline)
                .fontWeight(.bold)
        }
    }
}


struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}
