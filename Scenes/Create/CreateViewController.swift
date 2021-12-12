import UIKit

class CreateViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Crear contraseña"
        
        let storage = AccountsStorage(storage: SecureDataStorage())
        
        storage.save(
            account: Account(
                username: "test",
                provider: "test",
                password: "test",
                createdAt: Date()
            )
        ) { error in
            print(error)
        }
    }
}
