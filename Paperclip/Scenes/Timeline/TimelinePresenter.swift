
import Foundation

protocol TimelinePresentationLogic {
    func presentFetchProducts(with response: TimelineModels.FetchFromProducts.Response)
    func presentSearchedCategroy(with response: TimelineModels.FetchFromFiltredCategory.Response)
    
}

class TimelinePresenter: TimelinePresentationLogic {
    
    weak var viewController: TimelineDisplayLogic?
    
    func presentFetchProducts(with response: TimelineModels.FetchFromProducts.Response) {
        
        var productArray = response.productArray
        var displayedProduct = [TimelineModels.FetchFromProducts.ViewModel.DisplayedProduct]()
        sortListing(array: &productArray)
        
        productArray.forEach { (product) in
            let listing = product.listing
            let categoryName = product.categoryName

            let listingVM = TimelineModels.FetchFromProducts.ViewModel.Listing(listingTitle: listing?.listingTitle, listingPrice: listing?.listingPrice?.description, isUrgent: listing?.isUrgent, thumbUrl: URL(string: listing?.listingThumbUrlImage ?? ""), smallUrl: URL(string: listing?.listingSmallUrlImage ?? ""))
            
            let product =  TimelineModels.FetchFromProducts.ViewModel.DisplayedProduct(listing: listingVM, categoryName: categoryName)
      
            displayedProduct.append(product)
        }
        
        let viewModel = TimelineModels.FetchFromProducts.ViewModel(displayedProduct: displayedProduct)
        viewController?.displayFetchFromProducts(with:viewModel)
    }
    
    
        func presentSearchedCategroy(with response: TimelineModels.FetchFromFiltredCategory.Response) {
        
        let productArray = response.filtredCategory
        var displayedCategory = [TimelineModels.FetchFromFiltredCategory.ViewModel.Category]()
        
        productArray.forEach { (category) in
            
            var displayedProduct = [TimelineModels.FetchFromProducts.ViewModel.DisplayedProduct]()
            let categoryName = category.categoryName
            let products = category.filtredCategoryProducts
            //sortListing(array: &products)
            products.forEach { (product) in
                
                let listing = product.listing
                 let categoryName = product.categoryName
                let listingVm = TimelineModels.FetchFromProducts.ViewModel.Listing(listingTitle: listing?.listingTitle, listingPrice: listing?.listingPrice?.description, isUrgent: listing?.isUrgent, thumbUrl: URL(string: listing?.listingThumbUrlImage ?? ""), smallUrl: URL(string: listing?.listingSmallUrlImage ?? ""))
                
                let product = TimelineModels.FetchFromProducts.ViewModel.DisplayedProduct(listing: listingVm, categoryName: categoryName)
                
                
                displayedProduct.append(product)
            }
            
            
            let categoryVM = TimelineModels.FetchFromFiltredCategory.ViewModel.Category(categoryName: categoryName, displayedFiltredCategory: displayedProduct)
            displayedCategory.append(categoryVM)
        }
        
        let viewModel = TimelineModels.FetchFromFiltredCategory.ViewModel(displayedFiltredCategories: displayedCategory)
        viewController?.displayFiltredCategory(with:viewModel)
    }
    
    
    func sortListing( array: inout [TimelineModels.FetchFromProducts.Response.Product]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        array.sort { (lhs: TimelineModels.FetchFromProducts.Response.Product, rhs: TimelineModels.FetchFromProducts.Response.Product) -> Bool in
            return (lhs.listing?.listingCreationDate!.compare(rhs.listing!.listingCreationDate!) == .orderedDescending
            )}
        
        array.sort { (lhs: TimelineModels.FetchFromProducts.Response.Product, rhs: TimelineModels.FetchFromProducts.Response.Product) -> Bool in
         return (lhs.listing!.isUrgent! && !rhs.listing!.isUrgent!)
         }
    }
}
