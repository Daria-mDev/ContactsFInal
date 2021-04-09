//
//  JSONFileManager.swift
//  ContactsMultithreading
//
//  Created by user on 04.04.2021.
//

import Foundation

enum JSONFileManagerError: Error {
    case encodeFailure
    case writeFailure
    case fileURLFailure
}

struct JSONFileManager {
    private let fileManager: FileManager = FileManager.default
    private let jsonEncoder = JSONEncoder()
    
    func write(contactsList: [Contact]) throws {
        do {
            let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            guard let jsonUrl = url?.appendingPathComponent("contacts.json") else { throw JSONFileManagerError.fileURLFailure }
            let jsonData = try jsonEncoder.encode(contactsList)
            try jsonData.write(to: jsonUrl)
        } catch {
            print("\(JSONFileManagerError.writeFailure)")
        }
        
    }
    
    
    
}
