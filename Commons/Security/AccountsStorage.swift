import Foundation

typealias ErrorBlock = (_ error: Error?) -> Void

protocol AccountsStorageProtocol {
    func save(account: Account, onCompletion: ErrorBlock)
    func get() -> [Account]
    func delete(accountProvider: String)
}

final class AccountsStorage: AccountsStorageProtocol {
    // MARK: - Properties
    private var accountsKey: String {
        return ProcessInfo.processInfo.environment["STORAGE_KEY"] ?? .init()
    }
    private let storage: SecureDataStorageProtocol
    
    // MARK: - Life Cycle
    init(storage: SecureDataStorageProtocol = SecureDataStorage()) {
        self.storage = storage
    }
    
    // MARK: - Internal Methods
    func save(account: Account, onCompletion: ErrorBlock) {
        var currentStorage = get()
        currentStorage.append(account)
        
        do {
            try storage.save(currentStorage, key: accountsKey)
            
            onCompletion(nil)
        } catch let error {
            onCompletion(error)
        }
    }
    
    func delete(accountProvider: String) {
        let updatedStorage = get().filter { $0.provider != accountProvider }
        try? storage.save(updatedStorage, key: accountsKey)
    }
    
    func get() -> [Account] {
        do {
            return try storage.read(
                key: accountsKey,
                type: [Account].self
            )?.reversed() ?? []
        } catch let error {
            print(error)
            return []
        }
    }
}
