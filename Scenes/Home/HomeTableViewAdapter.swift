import UIKit

final class HomeTableViewAdapter: NSObject {
    // MARK: - Properties
    private weak var tableView: UITableView?
    weak var dataSource: HomeDataSourceProtocol?
    weak var cellDelegate: PasswordTableViewCellDelegate?
    
    private let cellIdentifier = String(describing: PasswordTableViewCell.self)
    private let defaultCellIdentifier = String(describing: UITableViewCell.self)
    
    // MARK: - Internal Methods
    
    func setup(tableView: UITableView) {
        self.tableView = tableView
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        registerCells()
    }
    
    // MARK: - Private Methods
    private func registerCells() {
        tableView?.register(
            UITableViewCell.self,
            forCellReuseIdentifier: defaultCellIdentifier
        )
        
        tableView?.register(
            UINib(nibName: cellIdentifier, bundle: .main),
            forCellReuseIdentifier: cellIdentifier
        )
    }
}

// MARK: - UITableViewDataSource
extension HomeTableViewAdapter: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let viewModel = dataSource?.dataSource[indexPath.row] else {
            return tableView.dequeueReusableCell(
                withIdentifier: defaultCellIdentifier,
                for: indexPath
            )
        }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath
        ) as? PasswordTableViewCell
        
        cell?.setup(
            indexPath: indexPath,
            with: viewModel,
            delegate: cellDelegate
        )
        
        return cell ?? tableView.dequeueReusableCell(
            withIdentifier: defaultCellIdentifier,
            for: indexPath
        )
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        dataSource?.dataSource.count ?? .zero
    }
}

// MARK: - UITableViewDelegate
extension HomeTableViewAdapter: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(
            style: .destructive,
            title: .delete
        ) { [weak self] _, _, block in
            self?.cellDelegate?.cellSwiped(
                at: indexPath,
                action: .delete
            )
            
            block(false)
        }
                
        return UISwipeActionsConfiguration(actions: [action])
    }
}

private extension String {
    static let delete = "Eliminar"
}
