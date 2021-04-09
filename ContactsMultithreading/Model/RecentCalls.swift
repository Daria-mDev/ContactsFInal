//
//  RecentCalls.swift
//  ContactsMultithreading
//
//  Created by user on 08.04.2021.
//

import Foundation

struct RecentCall {
    var firstName: String?
    let phone: String
    let time: String
}

struct RecentCallsList {
    static var recentCalls: [RecentCall] = []
}
