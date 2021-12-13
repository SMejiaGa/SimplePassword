import Foundation
import LocalAuthentication

enum BiometricType: String {
    case none = ""
    case touchID = "Touch ID"
    case faceID = "Face ID"
}

final class BiometricsHandler {
    // MARK: - Properties
    private let authContext = LAContext()
    private let localizedText = " continúa con %@"
    
    // MARK: - Internal methods
    func biometricType() -> BiometricType {
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                error: nil
            )
            
            switch authContext.biometryType {
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            default:
                return .none
            }
        }
        
        return authContext.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: nil
        ) ? .touchID : .none
    }
    
    func askPermissions(onFinished: @escaping (Bool) -> Void) {
        
        let formatedText = String(format: localizedText, "\(biometricType().rawValue)")
        let reason = formatedText
        
        authContext.evaluatePolicy(
            .deviceOwnerAuthentication,
            localizedReason: reason
        ) { success, error in
            onFinished(error == nil && success)
        }
    }
}
