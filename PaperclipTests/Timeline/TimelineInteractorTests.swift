
@testable import Paperclip
import XCTest

class TimelineInteractorTests: XCTestCase {
    
    // MARK: - Subject under test
    var sut: TimelineInteractor!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupTimelineInteractor()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupTimelineInteractor() {
        sut = TimelineInteractor()
    }
    
    class TimelinePresentationSpy: TimelinePresentationLogic {
        
        var presentFetchProducts = false
        var presentSearchedCategroy = false
        var responseFetchProducts: TimelineModels.FetchFromListProducts.Response!
        var responseFetchFiltredCategory: TimelineModels.FetchFromFiltredCategory.Response!
        
        func presentFetchProducts(with response: TimelineModels.FetchFromListProducts.Response) {
            presentFetchProducts = true
             self.responseFetchProducts = response
        }
        
        func presentSearchedCategroy(with response: TimelineModels.FetchFromFiltredCategory.Response) {
            presentSearchedCategroy = true
            self.responseFetchFiltredCategory = response
        }
    }
    
    class TimelineWorkerSpy: TimelineWorker
    {
        var fetchListingsCalled = false
        var fetchCategoriesCalled = false
        
        override func fetchListings(completion: @escaping ( _ listings: [ListingCodable]?, _ error: Error?) -> Void) {
            fetchListingsCalled = true
            
        }
        
        override func fetchCategories(completion: @escaping ( _ listings: [CategoryCodable]?, _ error: Error?) -> Void) {
            fetchCategoriesCalled = true
        }
    }
    
    // MARK: - TimelineBusinessLogic
    
    func testFetchFromProducts() {
        
        // Given
        let timelinePresentationSpy = TimelinePresentationSpy()
        sut.presenter = timelinePresentationSpy
        let timelineWorkerSpy = TimelineWorkerSpy()
        sut.worker = timelineWorkerSpy
        
        // When
        let request =  TimelineModels.FetchFromListProducts.Request()
        sut.fetchFromProducts(with: request)
        
        // Then
        XCTAssertTrue(timelineWorkerSpy.fetchListingsCalled, "fetchListings() should ask TimelineWorker to fetch listing")
        XCTAssertTrue(timelineWorkerSpy.fetchCategoriesCalled, "fetchCategories() should ask TimelineWorker to fetch listing")
    }
    
    func testSearchCategory() {
        
        // Given
        let timelinePresentationSpy = TimelinePresentationSpy()
        sut.presenter = timelinePresentationSpy
        let timelineWorkerSpy = TimelineWorkerSpy()
        sut.worker = timelineWorkerSpy
        
        // When
        let isoDate = "2016-04-14T10:44:00+0000"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:isoDate)!
        
        let listing = Listing(categoryId:5, listingId: 1461742431, listingTitle: "Pull bleu coton", listingDescription:"Produit pour faire un test", listingSiret: "23 44 55", listingPrice: 10, isUrgent: false, listingSmallUrlImage: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/df40ee665ce19053e5465c23180e9e9c75c4b71d.jpg", listingThumbUrlImage: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/df40ee665ce19053e5465c23180e9e9c75c4b71d.jpg", listingCreationDate:date)
        let product = Product(categoryName: "Mode", listing: listing)
        
        let listing2 = Listing(categoryId:2, listingId: 9466342431, listingTitle: "Nice test", listingDescription:"Entretien", listingSiret: "983 44 55", listingPrice: 300, isUrgent: false, listingSmallUrlImage: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/df40ee665ce19053e5465c23180e9e9c75c4b71d.jpg", listingThumbUrlImage: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/df40ee665ce19053e5465c23180e9e9c75c4b71d.jpg", listingCreationDate:date)
        let product2 = Product(categoryName: "Enfants", listing: listing2)
        
        sut.products =  [product, product2]
        let request = TimelineModels.FetchFromFiltredCategory.Request(categoryName: "Mode")
        sut.searchCategory(with: request)
        
        // Then
        let response: TimelineModels.FetchFromFiltredCategory.Response = timelinePresentationSpy.responseFetchFiltredCategory
        XCTAssertTrue(timelinePresentationSpy.presentSearchedCategroy, "searchCategory() should ask TimelinePresenter to present searched category")
        
        XCTAssertEqual(response.listFiltredCategories[0].categoryName, "Mode")
        XCTAssertEqual(response.listFiltredCategories[0].listProduct[0].listing?.categoryId, 5)

    }
}
