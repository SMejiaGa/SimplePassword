import UIKit

protocol CreateViewControllerDelegate: AnyObject {
    func passwordCreated()
}

final class CreateViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var providerTextField: UITextField!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    private let viewModel: CreateViewModel
    private weak var delegate: CreateViewControllerDelegate?
    
    // MARK: - Class Lifecycle
    init(
        viewModel: CreateViewModel,
        delegate: CreateViewControllerDelegate?
    ) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: String(describing: Self.self), bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        subscribeToViewModel()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = .title
        
        [providerTextField, usernameTextField, passwordTextField].forEach {
            $0.addTarget(
                self, action: #selector(validateInputs), for: .editingChanged
            )
        }
    }
    
    private func toggleLoading(visible: Bool) {
        visible ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
        providerTextField.isEnabled = !visible
        usernameTextField.isEnabled = !visible
        passwordTextField.isEnabled = !visible
        saveButton.isEnabled = !visible
    }
    
    private func subscribeToViewModel() {
        viewModel.stateDidChange = { [weak self] status in
            switch status {
            case .idle:
                return
                
            case .loading:
                self?.toggleLoading(visible: true)
                
            case .dataCreated:
                self?.toggleLoading(visible: false)
                self?.delegate?.passwordCreated()
                self?.navigationController?.popViewController(animated: true)
                
            case .error(let error):
                self?.alert(message: error.localizedDescription)
            }
        }
    }
    
    @objc private func validateInputs(_ input: UITextField) {
        saveButton.isEnabled = viewModel.isValidForm(
            provider: providerTextField.text,
            username: usernameTextField.text,
            password: passwordTextField.text
        )
    }
    
    @IBAction private func saveButtonTapped() {
        viewModel.createPassword(
            provider: providerTextField.safeText,
            username: usernameTextField.safeText,
            password: passwordTextField.safeText
        )
        
        delegate?.passwordCreated()
    }
}

private extension String {
    static let title = "Crear contraseña"
}

private extension UITextField {
    var safeText: String { text ?? .init() }
}

// MARK: - Intended for navigation
extension CreateViewController {
    static func instance(
        _ delegate: CreateViewControllerDelegate?
    ) -> CreateViewController {
        CreateViewController(
            viewModel: CreateViewModel(
                storage: AccountsStorage()
            ),
            delegate: delegate
        )
    }
}
