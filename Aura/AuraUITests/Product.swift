import Foundation

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let brand: String
    let price: String
    let imageURL: String
    var rating: Double? = nil
}
