import UIKit

final class HomeViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyStateLabel: UILabel!
    @IBOutlet private weak var createPasswordButton: UIButton!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    private let viewModel: HomeViewModel
    private let tableAdapter: HomeTableViewAdapter
    
    // MARK: - Class Lifecycle
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.tableAdapter = HomeTableViewAdapter()
        
        super.init(nibName: String(describing: Self.self), bundle: .main)
        
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        subscribeToViewModel()
        viewModel.fetchData()
    }
    
    // MARK: - IBActions
    @IBAction private func emptyStateButtonTapped() {
        navigateToPasswordCreation()
    }
    
    // MARK: - Private Methods
    
    private func navigateToPasswordCreation() {
        navigationController?.pushViewController(
            CreateViewController(),
            animated: true
        )
    }
    
    private func setupUI() {
        tableAdapter.setup(tableView: tableView)
        tableAdapter.dataSource = viewModel
        tableAdapter.cellDelegate = self
        
        createPasswordButton.isHidden = true
        emptyStateLabel.text = nil
        
        title = .title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func showEmptyState() {
        emptyStateLabel.text = .noAccountsCreated
        createPasswordButton.setTitle(.createAccountButton, for: .normal)
        tableView.isHidden = true
        createPasswordButton.isHidden = false
    }
    
    private func subscribeToViewModel() {
        viewModel.stateDidChange = { [weak self] status in
            switch status {
            case .idle:
                return
                
            case .loading:
                self?.activityIndicatorView?.startAnimating()
                
            case .dataLoaded:
                self?.activityIndicatorView?.stopAnimating()
                self?.tableView.reloadData()
                
            case .error(let error):
                self?.alert(title: .error, message: error.localizedDescription)
                
            case .noContent:
                self?.activityIndicatorView?.stopAnimating()
                self?.showEmptyState()
                
            case .modelUpdated(let indexPath):
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    private func confirmDeletion(at indexPath: IndexPath) {
        confirm(message: .confirmDeletion) { [weak self] _ in
            self?.viewModel.deletePassword(at: indexPath)
        }
    }
}

// MARK: - PasswordTableViewCellDelegate
extension HomeViewController: PasswordTableViewCellDelegate {
    func cellSwiped(
        at indexPath: IndexPath,
        action: PasswordCellAction
    ) {
        switch action {
        case .showPassword:
            viewModel.showPassword(at: indexPath)
            return
        }
    }
    
    func cellTapped(at indexPath: IndexPath) {
        viewModel.copyPasswordToClipboard(at: indexPath)
        alert(title: .notice, message: .passwordCopied)
    }
}

// MARK: - Intended for navigation
extension HomeViewController {
    static var instance: HomeViewController {
        HomeViewController(
            viewModel: HomeViewModel(storage: AccountsStorage())
        )
    }
}

private extension String {
    static let error = "Error"
    static let notice = "Noticia"
    static let title = "Contraseñas"
    static let createAccountButton = "Crear primera contraseña"
    static let passwordCopied = "Contraseña copiada al portapapeles."
    static let noAccountsCreated = "Aún no has creado ninguna contraseña."
    static let confirmDeletion = "¿Realmente deseas eliminar esa contraseña?"
}
