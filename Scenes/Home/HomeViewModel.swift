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

final class HomeViewModel: HomeDataSourceProtocol {
    // MARK: - Properties
    private let storage: AccountsStorageProtocol
    private(set) var dataSource = [PasswordCellViewModel]()
    var stateDidChange: ((HomeViewModelState) -> Void)?
    
    private var status: HomeViewModelState = .idle {
        didSet {
            mainThread {
                self.stateDidChange?(self.status)
            }
        }
    }
    
    // MARK: - Life Cycle
    init(storage: AccountsStorageProtocol) {
        self.storage = storage
    }
    
    // MARK: - Internal Methods
    func copyPasswordToClipboard(at indexPath: IndexPath) {
        let password = dataSource[indexPath.row].presentation.password
        UIPasteboard.general.string = password
    }
    
    func showPassword(at indexPath: IndexPath) {
        dataSource[indexPath.row].passwordVisible.toggle()
        status = .modelUpdated(indexPath: indexPath)
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
    
    private func mainThread(_ execute: @escaping () -> Void) {
        DispatchQueue.main.async {
            execute()
        }
    }
    
    private func validateEmptyState() {
        if dataSource.isEmpty {
            status = .noContent
        }
    }
}
