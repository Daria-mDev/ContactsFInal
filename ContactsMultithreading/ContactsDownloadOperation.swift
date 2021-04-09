//
//  ContactsDownloadOperation.swift
//  ContactsMultithreading
//
//  Created by user on 27.03.2021.
//

import Foundation

class ContactsDownloadOperation: Operation {
    private let contactsRepo: ContactsRepository
    var contactList: [Contact] = []
    
    init(contactsRepository contactsRepo: ContactsRepository) {
        self.contactsRepo = contactsRepo
    }
    
    override func main() {
        if isCancelled {
            return
        }
        do {
            contactList = try contactsRepo.getContacts()
        }
        catch {
            print(error)
        }
    }
}
