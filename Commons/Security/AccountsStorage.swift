import Foundation

typealias ErrorBlock = (_ error: Error?) -> Void

protocol AccountsStorageProtocol {
    func save(account: Account, onCompletion: ErrorBlock)
    func get() -> [Account]
}

final class AccountsStorage: AccountsStorageProtocol {
    // MARK: - Properties
    private let accountsKey = "Y6AbJzZfM6wFHWU2"
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
    
    func get() -> [Account] {
        do {
            return try storage.read(
                key: accountsKey,
                type: [Account].self
            ) ?? []
        } catch let error {
            print(error)
            return []
        }
    }
}
