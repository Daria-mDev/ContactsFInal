//
//  Contact.swift
//  ContactsMultithreading
//
//  Created by user on 24.03.2021.
//

import Foundation

struct Contact {
    var identifier: Int?
    var firstName: String
    var lastName: String
    var email: String?
    var phone: String
    var birthday: Date?
    var photoUrl: String?
    
    init (firstName: String, lastName: String, phone: String, birthday: Date?, email: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.birthday = birthday
        self.identifier = self.hashValue
    }
}

extension Contact: Codable {
    enum CodingKeys: String, CodingKey {
        case firstName = "firstname"
        case lastName = "lastname"
        case email = "email"
        case phone = "phone"
        case photoUrl
    }
}


extension Contact: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(firstName)
        hasher.combine(phone)
        hasher.combine(birthday)
    }
    
}
