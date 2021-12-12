import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case touch
    case face
}

final class BiometricsHandler {
    
    private let authContext = LAContext()
    private let localizedText = " continúa con %@ ID"
    
    func biometricType() -> BiometricType {
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
    
    func askPermissions(onFinished: @escaping (Bool) -> Void) {
        
        let formatedText = String(format: localizedText, "\(biometricType())")
        let reason = formatedText
        
        authContext.evaluatePolicy(
            .deviceOwnerAuthentication,
            localizedReason: reason
        ) { success, error in
            onFinished(error == nil && success)
        }
    }
}
