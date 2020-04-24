@testable import Paperclip
import XCTest

class TimelineViewControllerTests: XCTestCase {
    
    
    // MARK: - Subject under test
    
    var sut: TimelineViewController!
    var window: UIWindow!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupTimelineViewController()
    }
    
    // MARK: - Test setup
    
    func setupTimelineViewController() {
        sut = TimelineViewController(style: .plain)
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    class TableViewSpy: UITableView {
        // MARK: Method call expectations
        
        var reloadDataCalled = false
        
        // MARK: Spied methods
        
        override func reloadData()
        {
            reloadDataCalled = true
        }
    }
    
    // MARK: - TimelineDisplayLogic
    
    class TimelineBusinessLogicSpy: TimelineBusinessLogic {
        
        // MARK: Method call expectations
        
        var fetchFromProducts = false
        var searchCategory = false
        
        // MARK: Spied methods
        
        func fetchFromProducts(with request: TimelineModels.FetchFromListProducts.Request) {
            fetchFromProducts = true
        }
        
        func searchCategory(with request: TimelineModels.FetchFromFiltredCategory.Request) {
            searchCategory = true
        }
    }
    
    // MARK: - TimelineRouter
    
    class TimelineRouterSpy: TimelineRouter {
        
        // MARK: Method call expectations
        
        var routeToDetails = false
        
        // MARK: Spied methods
        
        override func routeToDetails(id: Int) {
            routeToDetails = true
        }
    }
    
    func testFetchFromProductsWhenViewWillAppear() {
        
        // Given
        let timelineBusinessLogicSpy = TimelineBusinessLogicSpy()
        sut.interactor = timelineBusinessLogicSpy
        self.loadView()
        // When
        sut.viewWillAppear(true)
        // Then
        XCTAssertTrue(timelineBusinessLogicSpy.fetchFromProducts, "Should fetch products")
    }
    
    func testSearchCategory() {
        
        // Given
        let timelineBusinessLogicSpy = TimelineBusinessLogicSpy()
        sut.interactor = timelineBusinessLogicSpy
        self.loadView()
        // When
        sut.resultSearchController.searchBar.text = "Mode"
        // Then
        XCTAssertTrue(timelineBusinessLogicSpy.searchCategory, "Should fetch category")
    }
    
    // MARK: - Test TimelineDisplayLogic
    
    func testDisplayFetchFromProducts() {
        
        // Given
        let tableView = sut.tableView
        
        let listing1 = TimelineModels.FetchFromListProducts.ViewModel.Listing(listingId: 1461742431, listingTitle: "Pull bleu coton", listingPrice:"10.00" , isUrgent: true, thumbUrl: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/df40ee665ce19053e5465c23180e9e9c75c4b71d.jpg"), smallUrl: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/df40ee665ce19053e5465c23180e9e9c75c4b71d.jpg"))
        
        let listing2 = TimelineModels.FetchFromListProducts.ViewModel.Listing(listingId: 1701863607, listingTitle: "Guitare électro acoustique", listingPrice: "170.00", isUrgent: false, thumbUrl: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/50b3d5870d57b3df834b43088171fef852997529.jpg"), smallUrl: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/50b3d5870d57b3df834b43088171fef852997529.jpg"))
        
        let product1 = TimelineModels.FetchFromListProducts.ViewModel.Product(categoryName: "Mode", listing: listing1)
        let product2 = TimelineModels.FetchFromListProducts.ViewModel.Product(categoryName: "Loisirs", listing: listing2)
        
        let product = [product1, product2]
        let vm = TimelineModels.FetchFromListProducts.ViewModel(listProduct: product)
        loadView()
        
        // When
        sut.displayFetchFromProducts(with: vm)
        
        // Then
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView!, cellForRowAt: indexPath) as?ProductCell
        
        XCTAssertEqual(cell?.productTitleLabel.text, "Pull bleu coton")
        XCTAssertEqual(cell?.productPriceLabel.text, "10.00 €")
    }
    
    func testDisplayFiltredCategory() {
        
        // Given
        let tableView = sut.tableView
        
        let listing1 = TimelineModels.FetchFromListProducts.ViewModel.Listing(listingId: 1461742431, listingTitle: "Pull bleu coton", listingPrice:"10.00" , isUrgent: true, thumbUrl: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/df40ee665ce19053e5465c23180e9e9c75c4b71d.jpg"), smallUrl: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/df40ee665ce19053e5465c23180e9e9c75c4b71d.jpg"))
        
        let listing2 = TimelineModels.FetchFromListProducts.ViewModel.Listing(listingId: 1701863443, listingTitle: "Bottines hiver fourrées + chaussons Décathlon", listingPrice: "15.00", isUrgent: false, thumbUrl: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/50b3d5870d57b3df834b43088171fef852997529.jpg"), smallUrl: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/50b3d5870d57b3df834b43088171fef852997529.jpg"))
        
        let product1 = TimelineModels.FetchFromListProducts.ViewModel.Product(categoryName: "Mode", listing: listing1)
        let product2 = TimelineModels.FetchFromListProducts.ViewModel.Product(categoryName: "Mode", listing: listing2)
        
        let productArray1 = [product1, product2]
        
        let category = TimelineModels.FetchFromFiltredCategory.ViewModel.Category(categoryName: "Mode", listProduct: productArray1)
        
        let categoryArray = [category]
        let vm = TimelineModels.FetchFromFiltredCategory.ViewModel(listFiltredCategories: categoryArray)
        
        // When
        sut.displayFiltredCategory(with: vm)
        
        // Then
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView!, cellForRowAt: indexPath) as?ProductCell
        
        XCTAssertEqual(cell?.productTitleLabel.text, "Pull bleu coton")
        XCTAssertEqual(cell?.productPriceLabel.text, "10.00 €")
    }
}



