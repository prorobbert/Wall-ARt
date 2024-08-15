//
//  RealTagsStore.swift
//  Domain
//
//  Created by Robbert Ruiter on 14/08/2024.
//

import Combine
import Foundation
import SwiftData

@Observable
public class RealTagsStore: TagsStore, ObservableObject {
    private let modelContext: ModelContext
    private var fetchedResultsController: FetchedResultsController<Tag>

    public var tags: [Tag] {
        fetchedResultsController.models
    }

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.fetchedResultsController = FetchedResultsController(
            modelContext: modelContext,
            sortDescriptors: [SortDescriptor(\.title)]
        )
        do {
            try fetchedResultsController.fetch()
        } catch {}
    }

    public func addTag() {
        let randomNumer = Int.random(in: 1...999)
        modelContext.insert(Tag(title: "random_\(randomNumer)"))
    }

    public func deleteTag(_ tag: Tag) {
        modelContext.delete(tag)
    }

    public func reloadSampleData() {
        do {
            try modelContext.delete(model: Tag.self)
            let mockTags: [Tag] = .mockedPreview
            for tag in mockTags {
                modelContext.insert(tag)
            }
            try fetchedResultsController.fetch()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
