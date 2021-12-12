import UIKit
import LocalAuthentication

enum BiometricType {
    case none
    case touch
    case face
}

final class LoginViewController: UIViewController {
    
    // MARK: -IBoutlets
    @IBOutlet private weak var checkAuthView: UIView!
    @IBOutlet private weak var loaderActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorlabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!
    
    // MARK: -Properties
    private let authContext = LAContext()
    private let localizedText = " continúa con %@ ID"
    
    // MARK: -IBActions
    @IBAction func continueButtonAction() {
        loaderActivityIndicator.startAnimating()
        askPermissions()
    }
    // MARK: -Class LifeCycle
    init() {
        super.init(nibName: String(describing: Self.self), bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        askPermissions()
    }
    
    // MARK: -Private functions
    private func biometricType() -> BiometricType {
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch authContext.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            @unknown default:
                fatalError()
            }
        } else {
            return authContext.canEvaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                error: nil
            ) ? .touch : .none
        }
    }
    
    private func setupView() {
        checkAuthView.isHidden = true
    }
    
    private func askPermissions() {
        
        let formatedText = String(format: localizedText, "\(biometricType())")
        let homeViewController = HomeViewController()
        let reason = formatedText
        authContext.evaluatePolicy(
            .deviceOwnerAuthentication,
            localizedReason: reason
        ) { [weak self] success, error in
            guard let self = self  else { return }
            DispatchQueue.main.async {
                if let error = error {
                    self.errorlabel.text = error.localizedDescription
                    self.loaderActivityIndicator.stopAnimating()
                } else {
                    self.present(homeViewController, animated: true, completion: nil)
                }
            }
        }
    }
}
