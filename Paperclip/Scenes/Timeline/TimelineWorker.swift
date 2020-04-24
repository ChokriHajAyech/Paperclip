
import Foundation

class TimelineWorker {
    
     var listingService = ServiceFactory.shared.makeListingsService()
     var categoryService = ServiceFactory.shared.makeCategoriesService()
    
    func fetchListings(completion: @escaping ( _ listings: [ListingCodable]?, _ error: Error?) -> Void) {
        listingService.listings { (response, error) in
            completion(response as? [ListingCodable], error)
        }
    }
    
    func fetchCategories(completion: @escaping ( _ listings: [CategoryCodable]?, _ error: Error?) -> Void) {
        categoryService.categories { (response, error) in
            completion(response as? [CategoryCodable], error)
        }
    }
}
