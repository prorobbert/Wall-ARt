//
//  ArtworksStore.swift
//  Domain
//
//  Created by Robbert Ruiter on 26/07/2024.
//

import SwiftData
import Foundation

@Observable
public class ArtworksStore: ArtworksRepository {
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
    
    public func addArtwork() {
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
        let artwork = Artwork(title: chosenTitle)
        modelContext.insert(artwork)
    }
    
    public func deleteArtwork(_ artwork: Artwork) {
        modelContext.delete(artwork)
    }
    
    public func fetchArtworks() throws {
        try fetchedResultsController.fetch()
    }
}
