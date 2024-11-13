//
//  PushNotificationsManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 28.06.2022.
//

import FirebaseMessaging

protocol PushNotificationsDelegate: AnyObject {
    func pushNotificationsDidReceive(authorizationStatus: PushNotificationsAuthorizationStatus)
    func pushNotificationsDidReceive(token: String?)
    func pushNotificationsDidReceive(model: PushNotificationsModel)
}

final class PushNotificationsManager: NSObject {
    static let shared = PushNotificationsManager()
    
    private let notificationsCenter = UNUserNotificationCenter.current()
    
    private var delegates = [Weak<PushNotificationsDelegate>]()
    
    private override init() {
        super.init()
        
        notificationsCenter.delegate = self
    }
}

// MARK: UNUserNotificationCenterDelegate
extension PushNotificationsManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        received(userInfo: response.notification.request.content.userInfo)
    }
}

// MARK: Public
extension PushNotificationsManager {
    func retriveAuthorizationStatus(handler: ((PushNotificationsAuthorizationStatus) -> Void)?) {
        notificationsCenter.getNotificationSettings { settings in
            DispatchQueue.main.async { [weak self] in
                let result: PushNotificationsAuthorizationStatus
                
                switch settings.authorizationStatus {
                case .authorized:
                    result = .authorized
                case .notDetermined:
                    result = .notDetermined
                default:
                    result = .denied
                }
                
                handler?(result)
                self?.delegates.forEach { $0.weak?.pushNotificationsDidReceive(authorizationStatus: result) }
            }
        }
    }
    
    func requestAuthorization() {
        notificationsCenter.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    self.delegates.forEach { $0.weak?.pushNotificationsDidReceive(token: nil) }
                }
            }
        }
    }
    
    func add(observer: PushNotificationsDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<PushNotificationsDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: PushNotificationsDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}

// MARK: Public (AppDelegate triggers)
extension PushNotificationsManager {
    func application(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        received(pushToken: deviceToken, error: nil)
    }
    
    func application(didFailToRegisterForRemoteNotificationsWithError error: Error) {
        received(pushToken: nil, error: error)
    }
    
    func application(didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        received(userInfo: userInfo)
        
        completionHandler(.noData)
    }
}

// MARK: Private
private extension PushNotificationsManager {
    func received(pushToken: Data?, error: Error?) {
        Messaging.messaging().apnsToken = pushToken
        
        DispatchQueue.main.async { [weak self] in
            if error == nil, let token = Messaging.messaging().fcmToken {
                self?.delegates.forEach { $0.weak?.pushNotificationsDidReceive(token: token) }
            } else {
                self?.delegates.forEach { $0.weak?.pushNotificationsDidReceive(token: nil) }
            }
        }
    }
    
    func received(userInfo: [AnyHashable : Any]) {
        let model = PushNotificationsModel(userInfo: userInfo)
        
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach { $0.weak?.pushNotificationsDidReceive(model: model) }
        }
    }
}
