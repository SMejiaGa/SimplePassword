import Foundation
import UserNotifications

final class LocalNotifications {
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    let oneWeekTimeInterval:Double = 604800
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(
            options: authOptions
        ) {
            (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }

    func sendNotification(title: String, body: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.badge = NSNumber(value: 1)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: oneWeekTimeInterval,
                                                        repeats: true)
        let request = UNNotificationRequest(identifier: "SimplePassword",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
