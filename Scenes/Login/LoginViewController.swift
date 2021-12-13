import UIKit
import LocalAuthentication

final class LoginViewController: UIViewController {
    
    // MARK: - IBoutlets
    @IBOutlet private weak var checkAuthView: UIView!
    @IBOutlet private weak var loaderActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorlabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!
    
    // MARK: - Properties
    private let viewModel: LoginViewModel
    private let errorMessage = "Intentalo nuevamente"
    
    // MARK: - IBActions
    @IBAction private func continueButtonAction() {
        viewModel.requestBiometrics()
    }
    
    // MARK: - Class LifeCycle
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        subscribeToViewModel()
        viewModel.requestBiometrics()
    }
    
    // MARK: - Private functions
    private func setupView() {
    }
    
    private func subscribeToViewModel() {
        viewModel.stateDidChange = { [weak self] status in
            switch status {
            case .idle:
                return
                
            case .loading:
                self?.loaderActivityIndicator.startAnimating()
    
            case .authenticationSuccessful:
                self?.navigateToHome()
                
            case .error(let error):
                self?.loaderActivityIndicator.stopAnimating()
                self?.alert(message: error.localizedDescription)
            }
        }
    }
    
    private func navigateToHome() {
        DispatchQueue.main.async {
            let navigationController = HomeViewController.instance
            navigationController.modalPresentationStyle = .fullScreen
            
            self.present(
                navigationController,
                animated: true,
                completion: nil
            )
        }
    }
}
