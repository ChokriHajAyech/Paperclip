
import Foundation
import UIKit

protocol TimelineDisplayLogic: class {
    func displayFetchFromProducts(with viewModel: TimelineModels.FetchFromListProducts.ViewModel)
    func displayFiltredCategory(with viewModel: TimelineModels.FetchFromFiltredCategory.ViewModel)
}

class TimelineViewController: UITableViewController {
    
    // MARK: - Controls

    private var interactor: TimelineBusinessLogic?
    private var router: (NSObjectProtocol & TimelineRoutingLogic & TimelineDataPassing)?
    private var resultSearchController = UISearchController()
    private var isEnabledFiltre = false
    private var indicator = UIActivityIndicatorView()
    
    private var viewModel: TimelineModels.FetchFromListProducts.ViewModel?  {
        didSet {
            DispatchQueue.main.async {
                self.loadUI()
            }
        }
    }
    private var viewModelFiltred: TimelineModels.FetchFromFiltredCategory.ViewModel?  {
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
        configureSpinner()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.indicator.translatesAutoresizingMaskIntoConstraints = true
        indicator.center = UIApplication.shared.keyWindow!.center
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
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.estimatedSectionHeaderHeight = 10
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.sectionFooterHeight = 0.0
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(CategoryHeaderView.self,
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
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.topItem?.title = "Liste des Produits"
    }
    
    // MARK: - Configure UIActivityIndicatorView
    
    func configureSpinner() {
        let frontWindow = UIApplication.shared.keyWindow
        indicator.center = frontWindow!.center
        frontWindow?.addSubview(indicator)
        indicator.startAnimating()
    }
    
    // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.cellId, for: indexPath) as! ProductCell
        var listing: TimelineModels.FetchFromListProducts.ViewModel.Listing?
        
        if isEnabledFiltre {
            listing = viewModelFiltred?.listFiltredCategories[indexPath.section].listProduct[indexPath.row].listing
        } else {
            listing = viewModel?.listProduct[indexPath.section].listing
        }
        cell.bind(listing)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRowsInSection: Int? = 1
        if isEnabledFiltre {
            numberOfRowsInSection = viewModelFiltred?.listFiltredCategories[section].listProduct.count
        }
        return numberOfRowsInSection ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        var numberOfSections = viewModel?.listProduct.count
        if isEnabledFiltre {
            numberOfSections = viewModelFiltred?.listFiltredCategories.count
        }
        return numberOfSections  ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
            "sectionHeader") as? CategoryHeaderView
        var categoryName = viewModel?.listProduct[section].categoryName
        if isEnabledFiltre {
            categoryName = viewModelFiltred?.listFiltredCategories[section].categoryName
        }        
        view?.title.text = categoryName
        return view
    }
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var idProduct = viewModel?.listProduct[indexPath.section].listing?.listingId
        if isEnabledFiltre {
            idProduct =  viewModelFiltred?.listFiltredCategories[indexPath.section].listProduct[indexPath.row].listing?.listingId
        }
        router?.routeToDetails(id: idProduct!)
    }
}

// MARK: TimelineDisplayLogic

extension TimelineViewController: TimelineDisplayLogic {
    
    func displayFiltredCategory(with viewModel: TimelineModels.FetchFromFiltredCategory.ViewModel) {
        viewModelFiltred = viewModel
    }
    
    func displayFetchFromProducts(with viewModel: TimelineModels.FetchFromListProducts.ViewModel) {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
        }
        self.viewModel = viewModel
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

