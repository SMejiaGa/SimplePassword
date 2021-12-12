import UIKit
import LocalAuthentication

final class LoginViewController: UIViewController {
    
    // MARK: -IBoutlets
    @IBOutlet private weak var checkAuthView: UIView!
    @IBOutlet private weak var loaderActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorlabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!
    
    // MARK: -Properties
    private let authContext = LAContext()
    private let viewModel: LoginViewModel
    private let errorMessage = "Intentalo nuevamente"
    
    // MARK: -IBActions
    @IBAction func continueButtonAction() {
        loaderActivityIndicator.startAnimating()
        biometrics.askPermissions { bioResults in
            if bioResults {
                
            }
        }
    }
    // MARK: -Class LifeCycle
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        biometrics.askPermissions { [weak self] bioResults in
            
            guard let self = self else {
                return
            }
            if bioResults {
                self.sendToHome()
            } else {
                self.alert(message: self.errorMessage)
            }
        }
    }
    
    // MARK: -Private functions    
    private func setupView() {
        checkAuthView.isHidden = true
    }
    
    private func biometricsState() {
        biometrics.askPermissions { bioResult in
            if bioResult {
                self.sendToHome()
            } else {
                self.errorlabel.text = self.errorMessage
                self.loaderActivityIndicator.stopAnimating()
            }
        }
        
    }
    
    private func subscribeToViewModel() {
        viewModel.stateDidChange = { [weak self] status in
            switch status {
            case .asking:
                self?.handleBiometrics()
            case .loading:
                return
            }
        }
    }
    
    private func sendToHome() {
        DispatchQueue.main.async {
            self.present(HomeViewController.instance, animated: true, completion: nil)
        }
    }
}
