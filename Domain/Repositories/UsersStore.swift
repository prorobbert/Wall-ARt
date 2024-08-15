//
//  UsersStore.swift
//  Domain
//
//  Created by Robbert Ruiter on 01/08/2024.
//

import Foundation
import Combine

public protocol UsersStore: AnyObject, ObservableObject {
    associatedtype EntryType: User
    var users: [EntryType] { get }
    func addUser()
    func deleteUser(_ user: EntryType)
    func getSingleUser() -> EntryType
    func reloadSampleData()
}
