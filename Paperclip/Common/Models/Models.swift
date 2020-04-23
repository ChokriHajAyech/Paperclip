
import Foundation

struct Listing {
    var categoryId: Int?
    var listingId: Int?
    var listingTitle: String?
    var listingDescription: String?
    var listingSiret: String?
    var listingPrice: Double?
    var isUrgent: Bool?
    var listingSmallUrlImage: String?
    var listingThumbUrlImage: String?
    var listingCreationDate: Date?
}
struct Product {
    var categoryName: String?
    var listing: Listing?
}
struct Categroy {
    var id: Int?
    var name: String?
}
