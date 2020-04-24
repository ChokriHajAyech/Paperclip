
@testable import Paperclip
import XCTest

class TimelinePresenterTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: TimelinePresenter!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupTimelinePresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupTimelinePresenter() {
        sut = TimelinePresenter()
    }
    
    class TimelineDisplayLogicSpy: TimelineDisplayLogic {
        
        // MARK: Method call expectations
        
        var displayFetchFromProductsCalled = false
        var displayFiltredCategoryCalled = false
        
        // MARK: Argument expectations
        
        var viewModel: TimelineModels.FetchFromListProducts.ViewModel!
        var viewModelFiltred: TimelineModels.FetchFromFiltredCategory.ViewModel!
        
        // MARK: Spied methods
        
        func displayFetchFromProducts(with viewModel: TimelineModels.FetchFromListProducts.ViewModel) {
            displayFetchFromProductsCalled = true
            self.viewModel = viewModel
        }
        
        func displayFiltredCategory(with viewModel: TimelineModels.FetchFromFiltredCategory.ViewModel) {
            displayFiltredCategoryCalled = true
            self.viewModelFiltred = viewModel
        }
        
    }
    
    // MARK: - Tests
    
    func testPresentFetchProducts()
    {
        // Given
        let timelineDisplayLogicSpy = TimelineDisplayLogicSpy()
        sut.viewController = timelineDisplayLogicSpy
        
        // When
        let isoDate = "2016-04-14T10:44:00+0000"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:isoDate)!
        
        let listing = Listing(categoryId:5, listingId: 1461742431, listingTitle: "Pull bleu coton", listingDescription:"Produit pour faire un test", listingSiret: "23 44 55", listingPrice: 10, isUrgent: false, listingSmallUrlImage: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/df40ee665ce19053e5465c23180e9e9c75c4b71d.jpg", listingThumbUrlImage: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/df40ee665ce19053e5465c23180e9e9c75c4b71d.jpg", listingCreationDate:date)
        let product = Product(categoryName: "Mode", listing: listing)
        let productArray = [product]
        let response = TimelineModels.FetchFromListProducts.Response(listProduct: productArray)
        
        sut.presentFetchProducts(with: response)
        
        // Then
        let viewModel = timelineDisplayLogicSpy.viewModel!
        XCTAssertTrue(timelineDisplayLogicSpy.displayFetchFromProductsCalled, "displayFetchFromProducts() should ask TimelineWorker to fetch listing")
        XCTAssertEqual(viewModel.listProduct[0].listing?.listingPrice, "10.0 €")
    }
    
    func testPresentSearchedCategroy()
    {
        // Given
        let timelineDisplayLogicSpy = TimelineDisplayLogicSpy()
        sut.viewController = timelineDisplayLogicSpy
        
        // When
        let isoDate = "2016-04-14T10:44:00+0000"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:isoDate)!
        
        //Create category 1
        let listing = Listing(categoryId:5, listingId: 1461742431, listingTitle: "Pull bleu coton", listingDescription:"Produit pour faire un test", listingSiret: "23 44 55", listingPrice: 10, isUrgent: false, listingSmallUrlImage: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/df40ee665ce19053e5465c23180e9e9c75c4b71d.jpg", listingThumbUrlImage: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/df40ee665ce19053e5465c23180e9e9c75c4b71d.jpg", listingCreationDate:date)
        let product = Product(categoryName: "Mode", listing: listing)
        let listProduct = [product]
        let category1 = TimelineModels.FetchFromFiltredCategory.Response.Category(categoryName: "Mode", listProduct: listProduct)
        
        //Create category 2
        let listing2 = Listing(categoryId:9, listingId: 89744864, listingTitle: "Pantalon rouge", listingDescription:"la mode de 2020", listingSiret: "98474T44", listingPrice: 40.0, isUrgent: true, listingSmallUrlImage: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/df40ee665ce19053e5465c23180e9e9c75c4b71d.jpg", listingThumbUrlImage: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/df40ee665ce19053e5465c23180e9e9c75c4b71d.jpg", listingCreationDate:date)
        let product2 = Product(categoryName: "Mode", listing: listing2)
        let listProduct2 = [product2]
        let category2 = TimelineModels.FetchFromFiltredCategory.Response.Category(categoryName: "Mode", listProduct: listProduct2)
        
        //Create response
        let categoryArray = [category1, category2]
        let response = TimelineModels.FetchFromFiltredCategory.Response(listFiltredCategories: categoryArray)
        sut.presentSearchedCategroy(with: response)
        
        // Then
        let viewModel = timelineDisplayLogicSpy.viewModelFiltred!
        XCTAssertTrue(timelineDisplayLogicSpy.displayFiltredCategoryCalled, "displayFetchFromProducts() should ask TimelineWorker to fetch listing")
        XCTAssertEqual(viewModel.listFiltredCategories.count, 2, "The number of categories must equals 2")
    }
    
}
