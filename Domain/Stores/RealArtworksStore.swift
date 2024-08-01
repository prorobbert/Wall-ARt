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
    private let fetchedResultsController: FetchedResultsController<Artwork>

    public var artworks: [Artwork] {
        fetchedResultsController.models
    }

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.fetchedResultsController = FetchedResultsController(
            modelContext: modelContext,
            sortDescriptors: [SortDescriptor(\.title, order: .reverse)]
        )
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
        print("Trying to add \(chosenTitle)")

        print("Is this a valid artist? \(artist.user.name)")
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
        print("The new artwork:")
        print("\(artwork.title) - \(artwork.medium.rawValue)")
        modelContext.insert(artwork)
    }

    public func deleteArtwork(_ artwork: Artwork) {
        modelContext.delete(artwork)
    }

    public func fetchArtworks() throws {
        try fetchedResultsController.fetch()
    }
}
