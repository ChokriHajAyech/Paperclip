import Foundation

class DemoCategoriesService: DemoService, CategoriesService {
    
    func categories(_ completion: @escaping ServiceCompletionHandler) {
        let file = "categories"
        invokeService(file: file, type: Category.self, completion: completion)
    }
}
