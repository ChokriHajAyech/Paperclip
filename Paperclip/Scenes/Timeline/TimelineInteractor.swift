
import Foundation

protocol TimelineBusinessLogic {
    func fetchFromProducts(with request: TimelineModels.FetchFromListProducts.Request)
    func searchCategory(with request: TimelineModels.FetchFromFiltredCategory.Request)
}

protocol TimeLineDataStore {
    var products: [Product]? { get  set }
}

class TimelineInteractor: TimelineBusinessLogic, TimeLineDataStore {
  
    var products: [Product]?
    var worker: TimelineWorker? = TimelineWorker()
    var presenter: TimelinePresentationLogic?
    
    func fetchFromProducts(with request: TimelineModels.FetchFromListProducts.Request) {
        var listingsArray = [Listing]()
        var cartegoriesArray = [Categroy]()
        
        let group = DispatchGroup()
        let concurrentQueue = DispatchQueue(label: "com.queue.Concurrent", attributes: .concurrent)
        
        group.enter()
        concurrentQueue.async(group: group) {
            self.worker?.fetchListings(completion: { (response, error) in
            
                if let listings = response {
                    listings.forEach({ (value) in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .long
                        dateFormatter.locale = Locale(identifier: "en_US")
                        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        let stringDate: String = value.creationDate!
                        let date = dateFormatter.date(from: stringDate)
                        

                        let listing = Listing(categoryId: value.categoryId, listingId: value.id, listingTitle: value.title, listingPrice: value.price, isUrgent: value.isUrgent, listingSmallUrlImage: value.smallUrlImage, listingThumbUrlImage: value.thumbUrlImage, listingCreationDate: date)
                        
                        
                        
                        listingsArray.append(listing)
                    })
                }
                group.leave()
            })
        }
        
        group.enter()
        concurrentQueue.async(group: group) {
            self.worker?.fetchCategories(completion: { (response, error) in
                if let categories = response {
                    categories.forEach({ (value) in
                        let category = Categroy(id: value.id, name: value.name)
                        cartegoriesArray.append(category)
                    })
                }
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.global()) {
            var productArray = [Product]()
            listingsArray.forEach { (listing) in
                if let category = cartegoriesArray.first(where: { $0.id == listing.categoryId }) {
                    let listing = Listing(categoryId: category.id,listingId: listing.listingId, listingTitle: listing.listingTitle, listingDescription: listing.listingDescription, listingSiret: listing.listingSiret, listingPrice: listing.listingPrice, isUrgent: listing.isUrgent, listingSmallUrlImage: listing.listingSmallUrlImage, listingThumbUrlImage: listing.listingThumbUrlImage, listingCreationDate: listing.listingCreationDate)
                    let product = Product(categoryName: category.name, listing: listing)
                    productArray.append(product)
                }
            }
          
            self.products = productArray
            
            let response = TimelineModels.FetchFromListProducts.Response(listProduct: productArray)
            self.presenter?.presentFetchProducts(with: response)
        }
    }
    
    func searchCategory(with request: TimelineModels.FetchFromFiltredCategory.Request) {
        
        var filtredCategoryProducts = [TimelineModels.FetchFromFiltredCategory.Response.Category]()
        let categoryName = request.categoryName
        let tmpProducts = products?.filter { ($0.categoryName?.contains(categoryName))! }
        let groupedProducts = Dictionary(grouping: tmpProducts!, by: { $0.categoryName! })
     
        groupedProducts.forEach { (categoryId, arrayProducts) in
            if arrayProducts.count > 0 {
               
                let categoryName = arrayProducts[0].categoryName
                
                let category = TimelineModels.FetchFromFiltredCategory.Response.Category(categoryName: categoryName!, listProduct: arrayProducts)
                filtredCategoryProducts.append(category)
            }
        }

        let response = TimelineModels.FetchFromFiltredCategory.Response(listFiltredCategories: filtredCategoryProducts)
       self.presenter?.presentSearchedCategroy(with: response)

      }
}

