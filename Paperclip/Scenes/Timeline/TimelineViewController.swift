
import Foundation
import UIKit

protocol TimelineDisplayLogic: class {
    func displayFetchFromProducts(with viewModel: TimelineModels.FetchFromListProducts.ViewModel)
    func displayFiltredCategory(with viewModel: TimelineModels.FetchFromFiltredCategory.ViewModel)
}

class TimelineViewController: UITableViewController {
    
    // MARK: - Controls
    
    private let cellId = "ListingCell"
    private var interactor: TimelineBusinessLogic?
    private var router: (NSObjectProtocol & TimelineRoutingLogic & TimelineDataPassing)?
    private var resultSearchController = UISearchController()
    private var isEnabledFiltre = false
    private var displayedProduct: [TimelineModels.FetchFromListProducts.ViewModel.Product]?  {
        didSet {
            DispatchQueue.main.async {
                self.loadUI()
            }
        }
    }
    private var displayedCategory: [TimelineModels.FetchFromFiltredCategory.ViewModel.Category]?  {
        didSet {
            DispatchQueue.main.async {
                self.loadUI()
            }
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchFromProducts()
    }
    
    override func loadView() {
        super.loadView()
        configureTableView()
        configureSearchController()
        configureNavigationBar()
    }
    
    // MARK: - Object lifecycle
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup VIP
    
    private func setup() {
        let viewController = self
        let interactor = TimelineInteractor()
        let presenter = TimelinePresenter()
        let router = TimelineRouter()
        viewController.interactor = interactor
        presenter.viewController = viewController
        interactor.presenter = presenter
        viewController.router = router
        router.dataStore = interactor
        router.viewController = viewController
    }
    
    // MARK: - Configure tableView
    
    private func configureTableView() {
        tableView.register(ProductCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.sectionFooterHeight = 0.0
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(TimeLineHeaderView.self,
            forHeaderFooterViewReuseIdentifier: "sectionHeader")
    }
    
    // MARK: - Configure SearchController
    
    private func configureSearchController () {
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Chercher une catégorie..."
            return controller
        })()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = resultSearchController
    }
    
    // MARK: - Configure NavigationBar
     
     private func configureNavigationBar () {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = "Liste des Produits"
     }
    
    // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProductCell
        var listing: TimelineModels.FetchFromListProducts.ViewModel.Listing?
        
        if isEnabledFiltre {
            listing = displayedCategory?[indexPath.section].listProduct[indexPath.row].listing
        } else {
            listing = displayedProduct?[indexPath.section].listing
        }
        cell.bind(listing)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRowsInSection: Int? = 1
        if isEnabledFiltre {
            numberOfRowsInSection = displayedCategory?[section].listProduct.count
        }
        return numberOfRowsInSection ?? 0
    }
    
     override func numberOfSections(in tableView: UITableView) -> Int {
         
         var numberOfSections = displayedProduct?.count
         if isEnabledFiltre {
             numberOfSections = displayedCategory?.count
         }
         return numberOfSections ?? 0
     }

//        func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            return 150
//        }
//
    override func tableView(_ tableView: UITableView,
            viewForHeaderInSection section: Int) -> UIView? {
       let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                   "sectionHeader") as? TimeLineHeaderView
        var categoryName =  displayedProduct?[section].categoryName
        if isEnabledFiltre {
            categoryName = displayedCategory?[section].categoryName
        }        
        view?.title.text = categoryName
       return view
    }
    
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        router?.routeToDetails(row: indexPath.row)
    }
  
}

// MARK: TimelineDisplayLogic

extension TimelineViewController: TimelineDisplayLogic {
    
    func displayFiltredCategory(with viewModel: TimelineModels.FetchFromFiltredCategory.ViewModel) {
        displayedCategory = viewModel.listFiltredCategories
    }
    
    func displayFetchFromProducts(with viewModel: TimelineModels.FetchFromListProducts.ViewModel) {
        displayedProduct = viewModel.listProduct
    }
}

// MARK: Event

extension TimelineViewController {
    
    func fetchFromProducts() {
        let request = TimelineModels.FetchFromListProducts.Request()
        interactor?.fetchFromProducts(with: request)
    }
    
    func searchData(for text: String) {
        let request = TimelineModels.FetchFromFiltredCategory.Request(categoryName: text)
        interactor?.searchCategory(with:request)
    }
    func loadUI() {
        tableView.reloadData()
    }
}

// MARK: UISearchResultsUpdating

extension TimelineViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            isEnabledFiltre = false
            self.loadUI()
            return
        }
        isEnabledFiltre = true
        searchData(for: text)
    }
}

