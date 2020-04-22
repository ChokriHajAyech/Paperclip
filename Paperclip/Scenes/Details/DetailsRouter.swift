
import Foundation

protocol DetailsRoutingLogic {
    func routeToTimeLine()
}

protocol DetailsDataPassing {
    var dataStore: DetailsDataStore? { get }
}

class DetailsRouter: NSObject,  DetailsRoutingLogic,  DetailsDataPassing {
    
    var dataStore: DetailsDataStore?
    var viewController: DetailsViewController?
    
    func routeToTimeLine() {
        
    }
    
}
