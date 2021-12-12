import Foundation

enum LoginViewModelState {
    case asking
    case loading
    case enterHome
    case error(error: Error)
}

enum LoginViewModelError: Error {
    case biometricsDidFail
}

final class LoginViewModel {
    var stateDidChange: ((LoginViewModelState) -> Void)?
    private let biometrics = BiometricsHandler()
    
    private var status: LoginViewModelState = .loading {
        didSet {
            DispatchQueue.main.async {
                self.stateDidChange?(self.status)
            }
        }
    }
    
    private func handleBiometrics() {
        biometrics.askPermissions { bioResult in
            if bioResult {
                self.status = .enterHome
            } else {
                self.status = .error(
                    error: LoginViewModelError.biometricsDidFail
                )
            }
        }
        
    }
    
    private func doWithBio() {
        status = .asking
    }
}
