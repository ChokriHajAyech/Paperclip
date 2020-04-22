
import Foundation
import UIKit

protocol TimelineDisplayLogic: class {
    func displayFetchFromProducts(with viewModel: TimelineModels.FetchFromProducts.ViewModel)
    func displayFiltredCategory(with viewModel: TimelineModels.FetchFromFiltredCategory.ViewModel)
}

class TimelineViewController: UITableViewController {
    
    // MARK: - Controls
    
    private let cellId = "ListingCell"
    private let isEnabledFiltre = false
    private var interactor: TimelineBusinessLogic?
    private var router: (NSObjectProtocol & TimelineRoutingLogic & TimelineDataPassing)?
    private var resultSearchController = UISearchController()
    private var displayedProduct: [TimelineModels.FetchFromProducts.ViewModel.DisplayedProduct]?  {
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
    }
    
    // MARK: - Object lifecycle
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup
    
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
        tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    // MARK: - Configure SearchController
    
    private func configureSearchController () {
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Chercher une catégorie..."
            tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        loadUI()
    }
    
    // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProductCell
        guard let product = displayedProduct?[indexPath.row] else { return cell }
        cell.bind(product.listing, categoryName: product.categoryName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isEnabledFiltre {
//            return displayedCategory?.count ?? 00
//        }
        return displayedProduct?.count ?? 0
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        if isEnabledFiltre {
//                   return displayedCategory?.count ?? 00
//               }
//        return
//    }
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
        displayedCategory = viewModel.displayedFiltredCategories
    }
    
    func displayFetchFromProducts(with viewModel: TimelineModels.FetchFromProducts.ViewModel) {
        displayedProduct = viewModel.displayedProduct
    }
}

// MARK: Event

extension TimelineViewController {
    
    func fetchFromProducts() {
        let request = TimelineModels.FetchFromProducts.Request()
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
            return
                //loadData()
        }
         searchData(for: text)
    }
    
}

