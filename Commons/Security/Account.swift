import Foundation

struct Account: Codable {
    let username: String
    let provider: String
    let password: String
    let createdAt: Date
}

extension Account {
    var asPasswordCellPresentation: PasswordCellViewModel.Presentation {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        return PasswordCellViewModel.Presentation(
            provider: provider,
            username: username,
            password: password,
            formattedDate: dateFormatterPrint.string(from: createdAt)
        )
    }
}
