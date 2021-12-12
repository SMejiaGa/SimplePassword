import Foundation

struct PasswordCellViewModel {
    // MARK: - Presentation
    struct Presentation {
        let provider: String
        let username: String
        let password: String
        let formattedDate: String
    }
    
    // MARK: - Properties
    let presentation: Presentation
    var passwordVisible: Bool
}
