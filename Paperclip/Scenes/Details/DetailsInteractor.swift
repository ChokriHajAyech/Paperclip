
import Foundation

protocol DetailsBusinessLogic {
    func fetchProductDetails(with request: DetailsModels.DetailsProduct.Request)
}

protocol DetailsDataStore {
    var product: Product? { get set }
}

class DetailsInteractor: DetailsDataStore, DetailsBusinessLogic {
    
    var product: Product?
    var presenter: DetailsPresentationLogic?
    
    func fetchProductDetails(with request: DetailsModels.DetailsProduct.Request) {
        
        let response = DetailsModels.DetailsProduct.Response(product: product)
         presenter?.presentProductDetails(with: response)
    }
}
