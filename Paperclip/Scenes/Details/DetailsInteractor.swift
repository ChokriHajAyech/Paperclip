
import Foundation

protocol DetailsBusinessLogic {
    
}

protocol DetailsDataStore {
    var product: TimelineModels.FetchFromProducts.Response.Product? { get set }
}

class DetailsInteractor: DetailsDataStore, DetailsBusinessLogic {
    var product: TimelineModels.FetchFromProducts.Response.Product?
    var presenter: DetailsPresentationLogic?
    

}
