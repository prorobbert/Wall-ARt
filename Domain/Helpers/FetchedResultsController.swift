//
//  FetchedResultsController.swift
//  Domain
//
//  Created by Robbert Ruiter on 29/07/2024.
//

import CoreData
import Foundation
import SwiftData

@Observable
@MainActor
final class FetchedResultsController<T: PersistentModel> {
    private(set) var models: [T] = []

    private let modelContext: ModelContext
    private var predicate: Predicate<T>?
    private var sortDescriptors: [SortDescriptor<T>]

    init(
        modelContext: ModelContext,
        predicate: Predicate<T>? = nil,
        sortDescriptors: [SortDescriptor<T>] = []
    ) {
        self.modelContext = modelContext
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
        setupNotification()
    }

    func fetch() throws {
        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortDescriptors)
        models = try modelContext.fetch(fetchDescriptor)
    }

    func updatePredicate(_ predicate: Predicate<T>? = nil) {
        self.predicate = predicate
    }

    func updateSortDescriptors(_ sortDescriptors: [SortDescriptor<T>] = []) {
        self.sortDescriptors = sortDescriptors
    }

    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didSave),
            name: .NSPersistentStoreRemoteChange,
            object: nil
        )
    }

    @objc private func didSave(_ notification: Notification) {
        do {
            try fetch()
        } catch {}
    }
}
