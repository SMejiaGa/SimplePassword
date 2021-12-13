import Foundation

enum LoginViewModelState {
    case idle
    case loading
    case authenticationSuccessful
    case error(error: Error)
}

enum LoginViewModelError: Error {
    case biometricsDidFail
}

final class LoginViewModel {
    var stateDidChange: ((LoginViewModelState) -> Void)?
    private let biometrics = BiometricsHandler()
    
    private var status: LoginViewModelState = .idle {
        didSet {
            DispatchQueue.main.async {
                self.stateDidChange?(self.status)
            }
        }
    }
    
    // MARK: - Private functions
    func requestBiometrics() {
        status = .loading

        biometrics.askPermissions { [weak self] bioResult in
            if bioResult {
                self?.status = .authenticationSuccessful
            } else {
                self?.status = .error(
                    error: LoginViewModelError.biometricsDidFail
                )
            }
        }
    }
}
