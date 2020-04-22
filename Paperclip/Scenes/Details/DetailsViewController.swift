
import UIKit

protocol DetailsDisplayLogic {
    
}

class DetailsViewController: UIViewController, DetailsDisplayLogic {
    
    var router: (NSObjectProtocol & DetailsRoutingLogic & DetailsDataPassing)?
    var interactor: DetailsBusinessLogic?
    
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
    
    override func viewDidLoad() { }
    
    override func viewWillAppear(_ animated: Bool) { }
    
    override func loadView() {
        setupView()
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
    }
}
