import Foundation

protocol ListingService: Cancellable {

    /// Subscribe to a channel.
    ///
    /// - parameter code: The code of the channel.
    /// - parameter completion: The completion handler.
    ///
    /// - note: The completion handler return a SubscribedChannel object.
    func listing(_ completion: @escaping ServiceCompletionHandler) -> Void
}
