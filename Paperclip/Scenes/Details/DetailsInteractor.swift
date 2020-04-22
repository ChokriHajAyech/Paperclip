
import Foundation

protocol DetailsBusinessLogic {
    
}

protocol DetailsDataStore {
    var product: TimelineModels.FetchFromListProducts.Response.Product? { get set }
}

class DetailsInteractor: DetailsDataStore, DetailsBusinessLogic {
    var product: TimelineModels.FetchFromListProducts.Response.Product?
    var presenter: DetailsPresentationLogic?
    

}
