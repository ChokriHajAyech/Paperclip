import Foundation

class ServiceFactory {
    
    static let shared = ServiceFactory()
    static let modeDemo = "demo"
    static let modeServer = "server"
    
    private init() {}
    
    func makeListingsService() -> ListingsService {
        if Conf.Services.mode == ServiceFactory.modeDemo {
            return DemoListingsService()
        }
        return ServerListingsService()
    }
    
    func makeCategoriesService() -> CategoriesService {
        if Conf.Services.mode == ServiceFactory.modeDemo {
            return DemoCategoriesService()
        }
        return ServerCategoriesService()
    }
    
}
