import UIKit

enum PasswordCellAction {
    case showPassword
}

protocol PasswordTableViewCellDelegate: AnyObject {
    func cellTapped(at indexPath: IndexPath)
    func cellSwiped(
        at indexPath: IndexPath,
        action: PasswordCellAction
    )
}

final class PasswordTableViewCell: UITableViewCell {
    // MARK: - UI References
    @IBOutlet private weak var providerLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var createdAtLabel: UILabel!
    
    // MARK: - Properties
    private var indexPath: IndexPath?
    private var viewModel: PasswordCellViewModel?
    private weak var delegate: PasswordTableViewCellDelegate?

    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        providerLabel.text = nil
        usernameLabel.text = nil
        passwordLabel.text = nil
        createdAtLabel.text = nil
    }
    
    // MARK: - Internal Methods
    
    func setup(
        indexPath: IndexPath,
        with viewModel: PasswordCellViewModel,
        delegate: PasswordTableViewCellDelegate?
    ) {
        self.indexPath = indexPath
        self.viewModel = viewModel
        self.delegate = delegate

        setupGestureRecognizer()
        
        setupUI(
            presentation: viewModel.presentation,
            passwordVisible: viewModel.passwordVisible
        )
    }
    
    // MARK: - Private Methods
    
    private func setupGestureRecognizer() {
        addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        )
    }
    
    private func setupUI(
        presentation: PasswordCellViewModel.Presentation,
        passwordVisible: Bool
    ) {
        providerLabel.text = presentation.provider
        usernameLabel.text = presentation.username
        createdAtLabel.text = presentation.formattedDate
        passwordLabel.text = passwordVisible ? presentation.password : "*************"
    }
    
    @objc private func cellTapped() {
        guard let indexPath = indexPath else { return }
        
        delegate?.cellTapped(at: indexPath)
    }
}
