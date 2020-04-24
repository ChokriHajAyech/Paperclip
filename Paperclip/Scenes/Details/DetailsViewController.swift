
import UIKit
import Foundation

protocol DetailsDisplayLogic {
    func displayProductDetails(with response: DetailsModels.DetailsProduct.ViewModel)
}

class DetailsViewController: UIViewController {
    
    var router: (NSObjectProtocol & DetailsRoutingLogic & DetailsDataPassing)?
    private var interactor: DetailsBusinessLogic?
    private var viewModel: DetailsModels.DetailsProduct.ViewModel?
    private var tableView = UITableView(frame: .zero, style: .grouped)
    private var safeArea: UILayoutGuide!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        displayProduct()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) { }
    
    override func loadView() {
        setupView()
        setupTableView()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        let viewController = self
        let interactor = DetailsInteractor()
        let presenter = DetailsPresenter()
        let router = DetailsRouter()
        viewController.interactor = interactor
        presenter.viewController = viewController
        interactor.presenter = presenter
        viewController.router = router
        router.dataStore = interactor
    }
    
    // MARK: Setup View
    
    private func setupView() {
        
        view = UIView()
        view.backgroundColor = .white
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        safeArea = view.layoutMarginsGuide
    }
    
    // MARK: Setup TableView
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.estimatedSectionHeaderHeight = 10
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.cellId)
        tableView.register(OtherDetailsCell.self, forCellReuseIdentifier: OtherDetailsCell.cellId)
        tableView.register(CategoryHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: "sectionHeader")
    }
    
    // MARK: - Configure NavigationBar
    
    private func configureNavigationBar () {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.title = "Informations"
    }
}

// MARK: - UITableViewDataSource

extension DetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.cellId, for: indexPath) as! ProductCell
            cell.bind(viewModel?.product?.listing)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OtherDetailsCell.cellId, for: indexPath) as! OtherDetailsCell
            cell.bind(viewModel?.product?.listing)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
            "sectionHeader") as? CategoryHeaderView
        let categoryName = viewModel?.product?.categoryName
        view?.title.text = categoryName
        return view
    }
}

extension DetailsViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: - DetailsDisplayLogic

extension DetailsViewController: DetailsDisplayLogic {
    
    func displayProductDetails(with response: DetailsModels.DetailsProduct.ViewModel) {
        viewModel = response
    }
}

// MARK: Event

extension DetailsViewController {
    
    func displayProduct() {
        let request = DetailsModels.DetailsProduct.Request()
        self.interactor?.fetchProductDetails(with: request)
    }
}

