import Foundation

class DemoListingService: DemoService, ListingService {
    
    /// Subscribe to a channel.
    ///
    /// - parameter code: The code of the channel.
    /// - parameter completion: The completion handler.
    ///
    /// - note: The completion handler return a SubscribedChannel object.
    func listing(_ completion: @escaping ServiceCompletionHandler) {
        let file = "listing"
        invokeService(file: file, type: Listing.self, completion: completion)
    }
}
