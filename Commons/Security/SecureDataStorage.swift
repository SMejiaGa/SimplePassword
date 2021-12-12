import Foundation
import SimpleKeychain

protocol SecureDataStorageProtocol {
    func save<T: Codable>(_ item: T, key: String) throws
    func read<T: Codable>(key: String, type: T.Type) throws -> T?
    func delete(key: String)
}

enum SecureDataStorageError: Error {
    case unableToSaveToKeychain
}

final class SecureDataStorage: SecureDataStorageProtocol {
    // MARK: - Properties
    private let source = A0SimpleKeychain()
    
    // MARK: - Internal Methods
    
    func save<T: Codable>(_ item: T, key: String) throws {
        let data = try JSONEncoder().encode(item)
        
        let operation = source.setData(data, forKey: key)
        
        if !operation {
            throw SecureDataStorageError.unableToSaveToKeychain
        }
    }
    
    func read<T: Codable>(key: String, type: T.Type) throws -> T? {
        guard let dataStored = source.data(forKey: key) else {
            return nil
        }
        
        return try JSONDecoder().decode(type, from: dataStored)
    }
    
    func delete(key: String) {
        _ = source.deleteEntry(forKey: key)
    }
}
