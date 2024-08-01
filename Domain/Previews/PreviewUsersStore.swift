//
//  PreviewUsersStore.swift
//  Domain
//
//  Created by Robbert Ruiter on 01/08/2024.
//

import Combine
import Foundation
import SwiftData

public final class PreviewUsersStore: UsersStore, ObservableObject {
    private let modelContext: ModelContext
    @Published public var users: [User]

    @MainActor
    public init(modelContext: ModelContext? = nil, users: [User] = .mockedPreview) {
        if let modelContext {
            self.modelContext = modelContext
        } else {
            let artworkDB = ArtworkDatabase(isStoredInMemoryOnly: true)
            self.modelContext = artworkDB.modelContainer.mainContext
        }
        self.users = users
    }

    public func addUser() {
        users.append(.mockedPreview)
    }

    public func deleteUser(_ user: User) {
        if let index = users.firstIndex(of: user) {
            users.remove(at: index)
        }
    }

    public func fetchUsers() throws {
        // No-op for preview
    }
}
