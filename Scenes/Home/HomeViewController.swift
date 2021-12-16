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
    
    private func setupNavigationBar() {
        title = Lang.Home.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Lang.Home.new,
            style: .plain,
            target: self,
            action: #selector(navigateToPasswordCreation)
        )
    }
    
    @objc private func navigateToPasswordCreation() {
        navigationController?.pushViewController(
            CreateViewController.instance(self),
            animated: true
        )
    }
    
    private func setupUI() {
        tableAdapter.setup(tableView: tableView)
        tableAdapter.dataSource = viewModel
        tableAdapter.cellDelegate = self
        
        createPasswordButton.isHidden = true
        emptyStateLabel.text = nil
        
        setupNavigationBar()
    }
    
    private func toggleEmptyState(visible: Bool) {
        emptyStateLabel.text = visible ? Lang.Home.noAccountsCreated : nil
        createPasswordButton.setTitle(Lang.Home.createAccountButton, for: .normal)
        
        tableView.isHidden = visible
        createPasswordButton.isHidden = !visible
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
                self?.toggleEmptyState(visible: false)
                self?.tableView.reloadData()
                
            case .error(let error):
                self?.alert(title: Lang.Home.error, message: error.localizedDescription)
                
            case .noContent:
                self?.activityIndicatorView?.stopAnimating()
                self?.toggleEmptyState(visible: true)
                
            case .modelUpdated(let indexPath):
                self?.tableView.reloadRows(at: [indexPath], with: .left)
                
            case .modelDeleted(let indexPath):
                self?.tableView.deleteRows(at: [indexPath], with: .right)
            }
        }
    }
    
    private func confirmDeletion(at indexPath: IndexPath) {
        confirm(message: Lang.Home.confirmDeletion) { [weak self] _ in
            self?.viewModel.deletePassword(at: indexPath)
        }
    }
    
    private func showPasswordMenu(at indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: nil,
            message: Lang.Home.cellActionMessages,
            preferredStyle: .actionSheet
        )
        
        alertController.addAction(
            UIAlertAction(
                title: Lang.Home.showPassword,
                style: .default,
                handler: { [weak self] _ in
                    self?.viewModel.showPassword(at: indexPath)
                }
            )
        )
        
        alertController.addAction(
            UIAlertAction(
                title: Lang.Home.copyToClipboard,
                style: .default,
                handler: { [weak self] _ in
                    self?.viewModel.copyPasswordToClipboard(at: indexPath)
                    //self?.alert(title: Lang.Home.notice, message: Lang.Home.passwordCopied)
                }
            )
        )
        
        alertController.addAction(
            UIAlertAction(
                title: Lang.Home.cancel,
                style: .cancel,
                handler: nil
            )
        )
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - PasswordTableViewCellDelegate
extension HomeViewController: PasswordTableViewCellDelegate {
    func cellSwiped(
        at indexPath: IndexPath,
        action: PasswordCellAction
    ) {
        switch action {
        case .delete:
            confirmDeletion(at: indexPath)
            return
        }
    }
    
    func cellTapped(at indexPath: IndexPath) {
        showPasswordMenu(at: indexPath)
    }
}

// MARK: - Intended for navigation
extension HomeViewController {
    static var instance: UINavigationController {
        UINavigationController(
            rootViewController: HomeViewController(
                viewModel: HomeViewModel(storage: AccountsStorage(), biometrics: BiometricsHandler())
            )
        )
    }
}

// MARK: - CreateViewControllerDelegate
extension HomeViewController: CreateViewControllerDelegate {
    func passwordCreated() {
        viewModel.fetchData()
    }
}
