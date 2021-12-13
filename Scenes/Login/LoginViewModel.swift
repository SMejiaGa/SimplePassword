import Foundation

enum LoginViewModelState {
    case idle
    case loading
    case authenticationSuccesful // REVISAR
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
    
    func requestBiometrics() {
        status = .loading
        // weak self
        biometrics.askPermissions { bioResult in
            if bioResult {
                self.status = .authenticationSuccesful
            } else {
                self.status = .error(
                    error: LoginViewModelError.biometricsDidFail
                )
            }
        }
    }
}
