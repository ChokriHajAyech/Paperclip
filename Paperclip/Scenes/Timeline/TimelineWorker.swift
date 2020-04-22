
import Foundation

class TimelineWorker {
    
     private var listingService = ServiceFactory.shared.makeCategoriesService()
     private var categoryService = ServiceFactory.shared.makeListingsService()
    
    func fetchListings(completion: @escaping ( _ listings: [Listing]?, _ error: Error?) -> Void) {
        ServiceFactory.shared.makeListingsService().listings { (response, error) in
            completion(response as? [Listing], error)
        }
    }
    
    func fetchCategories(completion: @escaping ( _ listings: [Category]?, _ error: Error?) -> Void) {
       ServiceFactory.shared.makeCategoriesService().categories { (response, error) in
            completion(response as? [Category], error)
        }
    }
}
