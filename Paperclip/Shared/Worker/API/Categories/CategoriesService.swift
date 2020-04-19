import Foundation

protocol CategoriesService: Cancellable {
    func categories(_ completion: @escaping ServiceCompletionHandler) -> Void
}
