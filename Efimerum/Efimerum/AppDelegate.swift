//
//  AppDelegate.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 28/01/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import UserNotifications

import FirebaseDatabase
import FirebaseMessaging
import FirebaseInstanceID
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: AppCoordinator?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        registerForRemoteNotifications(application)
        setupTokenRefreshObserver()
        FirebaseAuthenticationManager.Instance().setupLoginListener()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        if (Auth.auth().currentUser) == nil {
            Auth.auth().signInAnonymously(completion: { [weak self] (user, error) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.coordinator = AppCoordinator(window: window)
                strongSelf.coordinator?.start()
            })
        } else {
            coordinator = AppCoordinator(window: window)
            coordinator?.start()
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FirebaseMessagingManager.Instance().connect()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        FirebaseMessagingManager.Instance().disconnect()
    }
    
}

// MARK: Dynamic Links

extension AppDelegate {
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            let linkHandled = DynamicLinks.dynamicLinks()!.handleUniversalLink(incomingURL, completion: { [weak self] (dynamiclink, error) in
                guard let strongSelf = self else { return }
                if let dynamiclink = dynamiclink, let _ = dynamiclink.url {
                    strongSelf.handleIncomingDynamicLink(dynamicLink: dynamiclink)
                } else if let error = error{
                    print(error.localizedDescription)
                }
            })
            return linkHandled
        }
        return false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("I am handling a link through the openURL method!")
        if let dynamicLink = DynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url) {
            self.handleIncomingDynamicLink(dynamicLink: dynamicLink)
            return true
        }
        
        return false
    }
    
    
    // Handle the dynamic link
    func handleIncomingDynamicLink(dynamicLink: DynamicLink) {
        
        guard let pathComponents = dynamicLink.url?.pathComponents else { return }
        
        if let photoIdentifier = pathComponents.last {
            print("deberia mostrar la vista de single photo con la foto: \(photoIdentifier)")
            coordinator?.photoIdentifier = photoIdentifier
        }
  
    }
    
}

// MARK: Handle Notifications

extension AppDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
}

// MARK: Handle Notifications for iOS 10

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       
        completionHandler(.alert)
        
    }
    
    // receive notification in background
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let photoIdentifier = userInfo["photoId"] {
            coordinator?.photoIdentifier = (photoIdentifier as! String)
        }
        
        completionHandler()
    }
}


// MARK: Notifications
extension AppDelegate {
    

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    func registerForRemoteNotifications(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
    }
    
    func setupTokenRefreshObserver() {
        
        // Add observer for InstanceID token refresh callback.
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.tokenRefreshNotification),
//                                               name: .firInstanceIDTokenRefresh,
//                                               object: nil)
    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        FirebaseMessagingManager.Instance().connect()
    }
    
}


// MARK: FIRMessaging delegate for iOS 10
extension AppDelegate : MessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("hola")
    }
}

