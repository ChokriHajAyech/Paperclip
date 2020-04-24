
import Foundation

enum DetailsModels {
    
    enum DetailsProduct {
        struct Request {}
        struct Response {
            var product: Product?
        }
        struct ViewModel {
            struct Listing: listingDetailsProtocol {
                var listingTitle: String?
                var listingPrice: String?
                var listingDescription: String?
                var listingSiret: String?
                var thumbUrl: URL?
                var smallUrl: URL?
                var listingCreationDate: String?
                var isUrgent: Bool?
            }
             struct Product  {
                var categoryName: String?
                var listing: Listing?
            }
            var product: Product?
        }
    }
}
