
import Foundation

protocol DetailsPresentationLogic {
    func presentProductDetails(with response: DetailsModels.DetailsProduct.Response)
}

class DetailsPresenter: DetailsPresentationLogic {
    
    var viewController: DetailsDisplayLogic?
    func presentProductDetails(with response: DetailsModels.DetailsProduct.Response) {
        let list = response.product?.listing
        let categoryName = response.product?.categoryName
        let listing =  DetailsModels.DetailsProduct.ViewModel.Listing(listingTitle: list?.listingTitle, listingPrice: list?.listingPrice?.description, listingDescription: list?.listingDescription, listingSiret: list?.listingSiret, thumbUrl: URL(string: (list?.listingThumbUrlImage)!), smallUrl:  URL(string: (list?.listingSmallUrlImage)!), listingCreationDate: list?.listingCreationDate?.description, isUrgent: list?.isUrgent)
        
        let product = DetailsModels.DetailsProduct.ViewModel.Product(categoryName:categoryName, listing:listing)
        
        let response = DetailsModels.DetailsProduct.ViewModel(product: product)
        viewController?.displayProductDetails(with: response)
    }
}
