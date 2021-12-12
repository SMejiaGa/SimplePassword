import Foundation
import UIKit

extension UIViewController {
    func alert(
        title: String = "",
        message: String,
        ctaButton: String = "Ok",
        preferredStyle: UIAlertController.Style = .alert,
        completion: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )
        
        alertController.addAction(
            UIAlertAction(
                title: ctaButton,
                style: .default,
                handler: nil
            )
        )
        
        present(
            alertController,
            animated: true,
            completion: completion
        )
    }
    
    func confirm(
        title: String = "Confirmación",
        message: String,
        ctaButton: String = "Confirmar",
        cancelButton: String = "Cancelar",
        preferredStyle: UIAlertController.Style = .actionSheet,
        completion: @escaping (UIAlertAction) -> Void
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )
        
        alertController.addAction(
            UIAlertAction(
                title: ctaButton,
                style: .destructive,
                handler: completion
            )
        )
        
        alertController.addAction(
            UIAlertAction(
                title: cancelButton,
                style: .default,
                handler: nil
            )
        )
        
        present(
            alertController,
            animated: true,
            completion: nil
        )
    }
}
