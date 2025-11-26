import SwiftUI

// MARK: - Data Models


struct ProductCategory: Identifiable {
    let id = UUID()
    let name: String
    let imageURL: String
}

// MARK: - Home View

struct HomeView: View {
    
    // Sample Data
    let categories = [
        ProductCategory(name: "Skincare", imageURL: "https://images.unsplash.com/photo-1556228852-6d45a7ae2673?q=80&w=2080&auto=format&fit=crop"),
        ProductCategory(name: "Makeup", imageURL: "https://images.unsplash.com/photo-1620463055101-735392c25758?q=80&w=2187&auto=format&fit=crop"),
        ProductCategory(name: "Hair", imageURL: "https://images.unsplash.com/photo-1599387737838-66a352358506?q=80&w=2187&auto=format&fit=crop"),
        ProductCategory(name: "Body", imageURL: "https://images.unsplash.com/photo-1611779922936-0c8472a42a26?q=80&w=2187&auto=format&fit=crop")
    ]
    
    let newArrivals = [
        Product(name: "Aqua Bloom Mist", brand: "Aura Naturals", price: "$24", imageURL: "https://images.unsplash.com/photo-1625708458529-6e675e2857a2?q=80&w=2187&auto=format&fit=crop"),
        Product(name: "Sunset Palette", brand: "Chroma Cosmetics", price: "$45", imageURL: "https://images.unsplash.com/photo-1583241801234-3a29c13d2153?q=80&w=2187&auto=format&fit=crop")
    ]
    
    let recommended = [
        Product(name: "Silk Hair Oil", brand: "Mirage", price: "$28", imageURL: "https://images.unsplash.com/photo-1608248579934-2376b33411b5?q=80&w=2187&auto=format&fit=crop"),
        Product(name: "Cloud Cleanser", brand: "Aether Beauty", price: "$22", imageURL: "https://images.unsplash.com/photo-1629091342349-7a44170a3a78?q=80&w=2187&auto=format&fit=crop")
    ]

    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        TopNavBar()
                        CategoryScrollView(categories: categories)
                        PromoBanner()
                        ProductSection(title: "New Arrivals", products: newArrivals)
                        ProductSection(title: "Recommended For You", products: recommended)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)

            ShopView()
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Shop")
                }
                .tag(1)

            ScanView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                }
                .tag(2)
            
            WishlistView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Wishlist")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(4)
        }
    }
}

// MARK: - Helper Views

struct TopNavBar: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "line.horizontal.3")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            Spacer()
            Text("Aura").font(.title3).fontWeight(.medium)
            Spacer()
            HStack {
                Button(action: {}) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Button(action: {}) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct CategoryScrollView: View {
    let categories: [ProductCategory]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(categories) { category in
                    VStack {
                        AsyncImage(url: URL(string: category.imageURL)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle().fill(Color.gray.opacity(0.1)).frame(width: 60, height: 60)
                        }
                        Text(category.name).font(.caption)
                    }
                }
            }
        }
    }
}

struct PromoBanner: View {
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1600839282737-5241135b6a78?q=80&w=2803&auto=format&fit=crop")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.1)
            }

            VStack(alignment: .leading) {
                Text("Glow Up with")
                Text("Our New")
                Text("Vitamin C Serum")
            }
            .font(.system(size: 24, weight: .regular, design: .serif))
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.black.opacity(0.2))
        }
        .frame(height: 200)
        .cornerRadius(20)
        .clipped()
    }
}

struct ProductSection: View {
    let title: String
    let products: [Product]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(products) { product in
                        ProductCard(product: product)
                    }
                }
            }
        }
    }
}

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: product.imageURL)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .cornerRadius(15)
            } placeholder: {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 150, height: 150)
            }
            
            Text(product.name).fontWeight(.medium)
            Text("\(product.brand) - \(product.price)").font(.caption).foregroundColor(.gray)
        }
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
