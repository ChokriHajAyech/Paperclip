
import Foundation

enum TimelineModels {
    
    enum FetchFromListings {
        
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
            var listingsArray: [Listing]
        }
        struct ViewModel {}
    }
    
    enum FetchFromCategories {
        
        struct Request {  }
        struct Response {
            struct Categroy {
                var id: Int?
                var name: String?
            }
            var categroyArray: [Categroy]
        }
        struct ViewModel {}
    }
    
    enum FetchFromProducts {
        
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
                var listing: Listing?
                var categoryName: String?
            }
            var productArray: [Product]
        }
        
        struct ViewModel {
            struct Listing {
                var listingTitle: String?
                var listingPrice: String?
                var isUrgent: Bool?
                var thumbUrl: URL?
                var smallUrl: URL?
            }
            struct DisplayedProduct  {
                var listing: Listing?
                var categoryName: String?
            }
            var displayedProduct: [DisplayedProduct]
        }
    }
    
    enum FetchFromFiltredCategory {
        
        struct Request {
            var categoryName: String
        }
        struct Response {
            struct Category {
                var categoryName: String
                var filtredCategoryProducts: [FetchFromProducts.Response.Product]
            }
            var filtredCategory: [Category]
        }
        struct ViewModel {
            struct Category {
                var categoryName: String
                var displayedFiltredCategory: [FetchFromProducts.ViewModel.DisplayedProduct]
            }
            var displayedFiltredCategories: [Category]
        }
    }
}
