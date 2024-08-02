//
//  PreviewArtworkStore.swift
//  Domain
//
//  Created by Robbert Ruiter on 29/07/2024.
//

import Combine
import Foundation
import SwiftData

public final class PreviewArtworksStore: ArtworksStore, ObservableObject {
    private let modelContext: ModelContext
    @Published public var artworks: [Artwork]

    @MainActor
    public init(modelContext: ModelContext? = nil, artworks: [Artwork] = .mockedPreview) {
        if let modelContext {
            self.modelContext = modelContext
        } else {
            let artworkDB = ArtworkDatabase(isStoredInMemoryOnly: true)
            self.modelContext = artworkDB.modelContainer.mainContext
        }
        self.artworks = artworks
    }

    public func setSortOrder(_ sortOrder: ArtworkSortOrder) {}

    public func setFilter(_ filterString: String) {}

    public func addArtwork(for artist: Artist) {
        let artwork = Artwork(
            title: "Ethereal Whispers",
            story: "",
            medium: Medium.allCases.randomElement()!,
            price: 123.0,
            width: 300,
            height: 500,
            depth: 20,
            artist: Artist.mockedPreview
        )
        artworks.append(artwork)
    }

    public func deleteArtwork(_ artwork: Artwork) {
        if let index = artworks.firstIndex(of: artwork) {
            artworks.remove(at: index)
        }
    }
}
