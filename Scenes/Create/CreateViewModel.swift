import Foundation
import UIKit

enum CreateViewModelState {
    case idle
    case loading
    case dataCreated
    case error(error: Error)
}

final class CreateViewModel {
    // MARK: - Properties
    private let storage: AccountsStorageProtocol
    var stateDidChange: ((CreateViewModelState) -> Void)?
    
    private var status: CreateViewModelState = .idle {
        didSet {
            DispatchQueue.main.async {
                self.stateDidChange?(self.status)
            }
        }
    }
    
    // MARK: - Life Cycle
    init(storage: AccountsStorageProtocol) {
        self.storage = storage
    }
    
    // MARK: - Internal Methods
    func isValidForm(
        provider: String?,
        username: String?,
        password: String?
    ) -> Bool {
        provider?.isEmpty == false &&
        username?.isEmpty == false &&
        password?.isEmpty == false
    }
    
    func createPassword(
        provider: String,
        username: String,
        password: String
    ) {
        status = .loading
        
        let request = Account(
            username: username,
            provider: provider,
            password: password,
            createdAt: Date()
        )
        
        storage.save(account: request) { [weak self] error in
            if let error = error {
                self?.status = .error(error: error)
                return
            }
            
            self?.status = .dataCreated
        }
    }
}
