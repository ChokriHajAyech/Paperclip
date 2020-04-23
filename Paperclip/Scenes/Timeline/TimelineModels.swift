
import Foundation

enum TimelineModels {
    
    enum FetchFromListings {
        struct Request {}
        struct Response {
            var productArray: [Product]
        }
        struct ViewModel {}
    }
    
    enum FetchFromCategories {
        struct Request {}
        struct Response {
            var categroyArray: [Categroy]
        }
        struct ViewModel {}
    }
    
    enum FetchFromListProducts {
        struct Request {}
        struct Response {
            var listProduct: [Product]
        }
        struct ViewModel {
            struct Listing {
                let listingId: Int?
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
                var listProduct: [Product]
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
