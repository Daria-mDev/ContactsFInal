//
//  ContactsRepositoryError.swift
//  ContactsMultithreading
//
//  Created by user on 24.03.2021.
//

import Foundation

enum ContactsRepositoryError: Error {
    case urlFailure
    case jsonDecoderFailure
    case timeout
}
