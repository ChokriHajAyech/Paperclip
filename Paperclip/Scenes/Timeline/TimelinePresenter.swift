
import Foundation

protocol TimelinePresentationLogic {
    func presentFetchProducts(with response: TimelineModels.FetchFromListProducts.Response)
    func presentSearchedCategroy(with response: TimelineModels.FetchFromFiltredCategory.Response)
}

class TimelinePresenter: TimelinePresentationLogic {
    
    weak var viewController: TimelineDisplayLogic?
    
    func presentFetchProducts(with response: TimelineModels.FetchFromListProducts.Response) {
        
        var displayedProduct = [TimelineModels.FetchFromListProducts.ViewModel.Product]()
        var productArray = response.listProduct
        sortListing(array: &productArray)
        
        productArray.forEach { (product) in
            
            let listing = product.listing
            let categoryName = product.categoryName
            let listingVM = TimelineModels.FetchFromListProducts.ViewModel.Listing(listingId: listing?.listingId, listingTitle: listing?.listingTitle, listingPrice: (listing?.listingPrice?.description ?? "" + " €"), isUrgent: listing?.isUrgent, thumbUrl: URL(string: listing?.listingThumbUrlImage ?? ""), smallUrl: URL(string: listing?.listingSmallUrlImage ?? ""))
            let product =  TimelineModels.FetchFromListProducts.ViewModel.Product(categoryName: categoryName, listing: listingVM)
            displayedProduct.append(product)
        }
        
        let viewModel = TimelineModels.FetchFromListProducts.ViewModel(listProduct: displayedProduct)
        viewController?.displayFetchFromProducts(with:viewModel)
    }
    
    func presentSearchedCategroy(with response: TimelineModels.FetchFromFiltredCategory.Response) {
        
        let productArray = response.listFiltredCategories
        var displayedCategory = [TimelineModels.FetchFromFiltredCategory.ViewModel.Category]()
        
        productArray.forEach { (category) in
            
            var displayedProduct = [TimelineModels.FetchFromListProducts.ViewModel.Product]()
            let categoryName = category.categoryName
            var products = category.listProduct
            sortListing(array: &products)
            
            products.forEach { (product) in
                let listing = product.listing
                let categoryName = product.categoryName
                let listingVm = TimelineModels.FetchFromListProducts.ViewModel.Listing(listingId: listing?.listingId, listingTitle: listing?.listingTitle, listingPrice: (listing?.listingPrice?.description ?? "" + " €"), isUrgent: listing?.isUrgent, thumbUrl: URL(string: listing?.listingThumbUrlImage ?? ""), smallUrl: URL(string: listing?.listingSmallUrlImage ?? ""))
                
                let product = TimelineModels.FetchFromListProducts.ViewModel.Product(categoryName: categoryName, listing: listingVm)
                displayedProduct.append(product)
            }
            
            let categoryVM = TimelineModels.FetchFromFiltredCategory.ViewModel.Category(categoryName: categoryName, listProduct: displayedProduct)
            displayedCategory.append(categoryVM)
        }
        
        let viewModel = TimelineModels.FetchFromFiltredCategory.ViewModel(listFiltredCategories: displayedCategory)
        viewController?.displayFiltredCategory(with:viewModel)
    }
    
    
    func sortListing( array: inout [Product]) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        array.sort { (lhs: Product, rhs: Product) -> Bool in
            return (lhs.listing?.listingCreationDate?.compare((rhs.listing?.listingCreationDate) ?? Date()) == .orderedDescending
            )}
        
        array.sort { (lhs:Product, rhs: Product) -> Bool in
            return (lhs.listing?.isUrgent ?? false) && !(rhs.listing?.isUrgent ?? false)
        }
    }
}
