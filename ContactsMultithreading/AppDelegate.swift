//
//  AppDelegate.swift
//  ContactsMultithreading
//
//  Created by user on 25.03.2021.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        userNotificationCenter.requestAuthorization(options: options){ (success, error) in
            if error == nil {
                if !success {
                    print("Permission denied")
                }
            }
        }
        return true
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

