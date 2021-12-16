import Foundation
import UIKit

protocol HomeDataSourceProtocol: AnyObject {
    var dataSource: [PasswordCellViewModel] { get }
}

enum HomeViewModelState {
    case idle
    case loading
    case dataLoaded
    case error(error: Error)
    case noContent
    case modelUpdated(indexPath: IndexPath)
    case modelDeleted(indexPath: IndexPath)
}

enum HomeViewModelError: Error {
    case error
}

final class HomeViewModel: HomeDataSourceProtocol {
    // MARK: - Properties
    private let storage: AccountsStorageProtocol
    private let biometrics: BiometricsHandler
    private(set) var dataSource = [PasswordCellViewModel]()
    var stateDidChange: ((HomeViewModelState) -> Void)?
    
    private var status: HomeViewModelState = .idle {
        didSet {
            DispatchQueue.main.async {
                self.stateDidChange?(self.status)
            }
        }
    }
    
    // MARK: - Life Cycle
    init(storage: AccountsStorageProtocol, biometrics: BiometricsHandler) {
        self.storage = storage
        self.biometrics = biometrics
    }
    
    // MARK: - Internal Methods
    func copyPasswordToClipboard(at indexPath: IndexPath) {
        biometrics.askPermissions { [weak self] permissionSucceded in
            guard let self = self else { return }
            if permissionSucceded {
                let password = self.dataSource[indexPath.row].presentation.password
                UIPasteboard.general.string = password
            } else {
                self.status = .error(error: HomeViewModelError.error)
            }
        }
        
    }
    
    func showPassword(at indexPath: IndexPath) {
        biometrics.askPermissions { [weak self] permissionSucceded in
            guard let self = self else { return }
            if permissionSucceded {
                self.dataSource[indexPath.row].passwordVisible.toggle()
                self.status = .modelUpdated(indexPath: indexPath)
            } else {
                self.status = .error(error: HomeViewModelError.error)
            }
        }
    }
    
    func deletePassword(at indexPath: IndexPath) {
        storage.delete(
            accountProvider: dataSource[indexPath.row].presentation.provider
        )
        
        dataSource.remove(at: indexPath.row)
        status = .modelDeleted(indexPath: indexPath)
        
        validateEmptyState()
    }
    
    func fetchData() {
        status = .loading
        
        let accounts = storage.get()
        
        if accounts.isEmpty {
            status = .noContent
            return
        }
        
        dataSource = accounts.map {
            PasswordCellViewModel(
                presentation: $0.asPasswordCellPresentation,
                passwordVisible: false
            )
        }
        
        status = .dataLoaded
    }
    
    // MARK: - Private Methods
    
    private func validateEmptyState() {
        if dataSource.isEmpty {
            status = .noContent
        }
    }
}
