//
//  RealArtistsStore.swift
//  Domain
//
//  Created by Robbert Ruiter on 01/08/2024.
//

import Combine
import Foundation
import SwiftData

@Observable
@MainActor
public class RealArtistsStore: ArtistsStore, ObservableObject {
    private let modelContext: ModelContext
    private let fetchedResultsController: FetchedResultsController<Artist>

    public var artists: [Artist] {
        fetchedResultsController.models
    }

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.fetchedResultsController = FetchedResultsController(
            modelContext: modelContext,
            sortDescriptors: [SortDescriptor(\.user.firstName), SortDescriptor(\.user.lastName)]
        )
        do {
            try fetchedResultsController.fetch()
        } catch {}
    }

    public func addArtist(for user: User) {
        let artistStories = [
            "I am the first artist there ever was",
            "I only pain using my toes",
            "Creating stuff with AI makes me an artist too, right?"
        ]
        let artist = Artist(personalInfo: artistStories.randomElement()!, user: user)
        modelContext.insert(artist)
    }

    public func deleteArtist(_ artist: Artist) {
        modelContext.delete(artist)
    }

    public func fetchArtists() throws {
        try fetchedResultsController.fetch()
    }

    public func getRandomArtist() throws -> Artist {
        if !artists.isEmpty {
            return artists.randomElement()!
        } else {
            fatalError()
        }
    }

    public func reloadSampleData(users: [User]) throws {
        do {
            try modelContext.delete(model: Artist.self)
            for user in users {
                addArtist(for: user)
            }
            try fetchedResultsController.fetch()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
