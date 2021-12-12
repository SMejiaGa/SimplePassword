import UIKit
import LocalAuthentication

enum BiometricType {
    case none
    case touch
    case face
}

final class LoginViewController: UIViewController {
    
    let authContext = LAContext()
    let averageRadius: CGFloat = 10
    
    @IBOutlet private weak var checkAuthView: UIView!
    @IBOutlet weak var loaderActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func continueButtonAction() {
        self.loaderActivityIndicator.startAnimating()
        askPermissions()
    }
        
    init() {
        super.init(nibName: String(describing: Self.self), bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        askPermissions()
    }
    
    private func biometricType() -> BiometricType {
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
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
                error: nil) ? .touch : .none
        }
    }
    
    private func setupView() {
        checkAuthView.isHidden = true
        checkAuthView.layer.cornerRadius = averageRadius
        continueButton.layer.cornerRadius = averageRadius
    }
    
    private func askPermissions() {
        let homeViewController = HomeViewController()
        let reason = "Log in with \(biometricType()) ID"
            authContext.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: reason
            ) { success, error in
                if success {
                    self.present(homeViewController, animated: true, completion: nil)
                } else {
                    DispatchQueue.main.async {
                        self.animateView()
                        self.loaderActivityIndicator.stopAnimating()
                    }
                }
            }
    }
    
    private func animateView() {
        UIView.transition(
            with: checkAuthView,
            duration: 0.4,
            options: .transitionCrossDissolve,
            animations: {
                self.checkAuthView.isHidden = false
        })
    }
}
