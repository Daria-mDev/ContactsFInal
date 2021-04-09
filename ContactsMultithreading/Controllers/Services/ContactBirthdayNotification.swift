//
//  ContactBirthdayNotification.swift
//  ContactsMultithreading
//
//  Created by user on 04.04.2021.
//

import Foundation
import UserNotifications

class ContactBirthdayNotification {
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    func setBirthdayNotification(forContact contact: Contact) {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        userNotificationCenter.requestAuthorization(options: options){ (success, error) in
            if error == nil {
                if !success {
                    print("Permission denied")
                }
            }
        }
        
        let content = UNMutableNotificationContent()
        if let birthday = contact.birthday, let identifier = contact.identifier  {
            content.title = "\(contact.firstName)'s birthday!"
            content.body = "Date of birth: \(birthday)"
            content.sound = .default
            content.badge = 1
            let notificationDate = Calendar.current.dateComponents([.month, .day], from: birthday)
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: true)
            let request = UNNotificationRequest(identifier: identifier.description, content: content, trigger: trigger)
            userNotificationCenter.add(request, withCompletionHandler: { error in
                if let error = error {
                    print("\(error.localizedDescription)")
                }
            })
        }
    }
}
