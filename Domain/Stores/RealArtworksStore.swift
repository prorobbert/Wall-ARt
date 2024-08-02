//
//  ArtworksStore.swift
//  Domain
//
//  Created by Robbert Ruiter on 26/07/2024.
//

import Combine
import Foundation
import SwiftData

@Observable
public class RealArtworksStore: ArtworksStore, ObservableObject {
    private let modelContext: ModelContext
    private var fetchedResultsController: FetchedResultsController<Artwork>

    public var artworks: [Artwork] {
        fetchedResultsController.models
    }

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.fetchedResultsController = FetchedResultsController(
            modelContext: modelContext,
            sortDescriptors: [SortDescriptor(\.title)]
        )
    }

    public func setSortOrder(_ sortOrder: ArtworkSortOrder) {
        let sortDescriptors: [SortDescriptor<Artwork>] = {
            switch sortOrder {
            case .title:
                return [SortDescriptor(\Artwork.title)]
            case .artist:
                return [SortDescriptor(\Artwork.artist.user.firstName), SortDescriptor(\Artwork.title)]
            case .medium:
                return [SortDescriptor(\Artwork.medium), SortDescriptor(\Artwork.title)]
            }
        }()

        fetchedResultsController.updateSortDescriptors(sortDescriptors)

        do {
            try fetchedResultsController.fetch()
        } catch {
            print("Failed to fetch artworks with new sort order: \(error)")
        }
    }

    public func setFilter(_ filterString: String) {
        let predicate = #Predicate<Artwork> { artwork in
            artwork.title.localizedStandardContains(filterString)
            || filterString.isEmpty
        }

        fetchedResultsController.updatePredicate(predicate)

        do {
            try fetchedResultsController.fetch()
        } catch {
            print("Failed to fetch artworks with filter: \(error)")
        }
    }

    public func addArtwork(for artist: Artist) {
        let artworkTitles = [
            "Ethereal Whispers",
            "Solitude's Embrace",
            "Infinite Horizons",
            "Silent Echoes",
            "Radiant Dreams",
            "Twilight Serenity",
            "Fractured Reflections",
            "Mystic Pathways",
            "Celestial Dances",
            "Ephemeral Beauty"
        ]
        let chosenTitle = artworkTitles.randomElement()!
        let artwork = Artwork(
            title: chosenTitle,
            story: "",
            medium: Medium.allCases.randomElement()!,
            price: 123.0,
            width: 300,
            height: 500,
            depth: 20,
            artist: artist
        )
        modelContext.insert(artwork)
    }

    public func deleteArtwork(_ artwork: Artwork) {
        modelContext.delete(artwork)
    }

    public func fetchArtworks() throws {
        try fetchedResultsController.fetch()
    }
}
