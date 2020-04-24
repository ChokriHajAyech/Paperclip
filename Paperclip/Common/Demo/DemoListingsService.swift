import Foundation

class DemoListingsService: DemoService, ListingsService {
    
    func listings(_ completion: @escaping ServiceCompletionHandler) {
        let file = "listing"
        invokeService(file: file, type: [ListingCodable].self, completion: completion)
    }
}
