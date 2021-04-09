//
//  TabBarController.swift
//  ContactsMultithreading
//
//  Created by user on 03.04.2021.
//

import UIKit


class TabBarController: UITabBarController {
    
    struct TabBarItem {
        static let contactsTab = 0
        static let recentCallsTab = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        
        let isRecentDefaultTab: Bool = userDefaults.bool(forKey: "recentCalls")
        
        if isRecentDefaultTab {
            self.selectedIndex = TabBarItem.recentCallsTab
        }
        else {
            self.selectedIndex = TabBarItem.contactsTab
        }
    }
}
