
import Foundation

enum TimelineModels {
    
    enum FetchFromListings {
        struct Request {}
        struct Response {
            struct Product {
                var categoryId: Int?
                var listingTitle: String?
                var listingPrice: Double?
                var isUrgent: Bool?
                var listingId: Int?
                var listingSmallUrlImage: String?
                var listingThumbUrlImage: String?
                var listingCreationDate: Date?
            }
            var productArray: [Product]
        }
        struct ViewModel {}
    }
    
    enum FetchFromCategories {
        struct Request {}
        struct Response {
            struct Categroy {
                var id: Int?
                var name: String?
            }
            var categroyArray: [Categroy]
        }
        struct ViewModel {}
    }
    
    enum FetchFromListProducts {
        struct Request {}
        struct Response {
            struct Listing {
                var categoryId: Int?
                var listingTitle: String?
                var listingPrice: Double?
                var isUrgent: Bool?
                var listingId: Int?
                var listingSmallUrlImage: String?
                var listingThumbUrlImage: String?
                var listingCreationDate: Date?
            }
            struct Product {
                var categoryName: String?
                var listing: Listing?
            }
            var listProduct: [Product]
        }
        
        struct ViewModel {
            struct Listing {
                var listingTitle: String?
                var listingPrice: String?
                var isUrgent: Bool?
                var thumbUrl: URL?
                var smallUrl: URL?
            }
            struct Product  {
                var categoryName: String?
                var listing: Listing?
            }
            var listProduct: [Product]
        }
    }
    
    enum FetchFromFiltredCategory {
        
        struct Request {
            var categoryName: String
        }
        struct Response {
            struct Category {
                var categoryName: String
                var listProduct: [FetchFromListProducts.Response.Product]
            }
            var listFiltredCategories: [Category]
        }
        struct ViewModel {
            struct Category {
                var categoryName: String
                var listProduct: [FetchFromListProducts.ViewModel.Product]
            }
            var listFiltredCategories: [Category]
        }
    }
}
