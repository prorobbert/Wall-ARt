//
//  RealUsersStore.swift
//  Domain
//
//  Created by Robbert Ruiter on 01/08/2024.
//

import Combine
import Foundation
import SwiftData

@Observable
public class RealUsersStore: UsersStore, ObservableObject {
    private let modelContext: ModelContext
    private let fetchedResultsController: FetchedResultsController<User>

    public var users: [User] {
        fetchedResultsController.models
    }

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.fetchedResultsController = FetchedResultsController(
            modelContext: modelContext,
            sortDescriptors: [SortDescriptor(\.firstName), SortDescriptor(\.lastName)]
        )
        do {
            try fetchedResultsController.fetch()
        } catch {}
    }

    public func addUser() {
        modelContext.insert(User.mockedPreview)
    }

    public func deleteUser(_ user: User) {
        modelContext.delete(user)
    }

    public func getSingleUser() -> User {
        if users.isEmpty {
            addUser()
            do {
                try fetchedResultsController.fetch()
            } catch {}
        }
        return users.randomElement()!
    }
}