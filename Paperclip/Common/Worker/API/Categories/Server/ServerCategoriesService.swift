import Foundation

class ServerCategoriesService: ServerService, CategoriesService {

    func categories(_ completion: @escaping ServiceCompletionHandler) -> Void {
        let path = Conf.Services.categories
        invokeService(path: path, method: "GET", type: [Category].self, completion: completion)
    }
}
