import Foundation

protocol ListingsService: Cancellable {
    func listings(_ completion: @escaping ServiceCompletionHandler) -> Void
}
