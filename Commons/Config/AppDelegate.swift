import UIKit

@main class AppDelegate: UIResponder {
    // MARK: - Properties
    var window: UIWindow?
    
    // MARK: - Private Methods
    private func setupNavigator() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LoginViewController(viewModel: LoginViewModel())
        window?.makeKeyAndVisible()
    }
    
}

// MARK: - UIResponder, UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UIApplication.shared.applicationIconBadgeNumber = 0
        setupNavigator()
        return true
    }
}
