import Foundation

class ServerCategoriesService: ServerService, CategoriesService {

    func categories(_ completion: @escaping ServiceCompletionHandler) -> Void {
        let path = Conf.Services.categories
        invokeService(path: path, method: "GET", type: [CategoryCodable].self, completion: completion)
    }
}
