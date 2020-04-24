
import UIKit

protocol TimelineRoutingLogic {
    func routeToDetails(id: Int)
}

protocol TimelineDataPassing {
    var dataStore: TimeLineDataStore? { get }
}

class TimelineRouter: NSObject, TimelineRoutingLogic, TimelineDataPassing {
    
    var viewController: TimelineViewController?
    var dataStore: TimeLineDataStore?
    
    func routeToDetails(id: Int) {
        let destinationVC = DetailsViewController()
        var destinationDS = destinationVC.router?.dataStore
        passDataToDetails(source: dataStore!, destination: &(destinationDS!), idProduct: id)
        navigateToDetails(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Passing data
    
    func passDataToDetails(source: TimeLineDataStore, destination: inout DetailsDataStore, idProduct: Int) {
        
        destination.product = source.products?.first(where: { $0.listing?.listingId == idProduct
        })
    }
    
    // MARK: Navigation
    
    func navigateToDetails(source: TimelineViewController, destination: DetailsViewController) {
        
        source.navigationController?.pushViewController(destination, animated: true)
    }
}
