//
//  PreviewArtworkStore.swift
//  Domain
//
//  Created by Robbert Ruiter on 29/07/2024.
//

import Foundation
import Combine
import SwiftData

public final class PreviewArtworkStore: ArtworksStore, ObservableObject {
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
    
    public func addArtwork() {
        let artwork = Artwork(title: "Preview Artwork")
        artworks.append(artwork)
    }
    
    public func deleteArtwork(_ artwork: Artwork) {
        if let index = artworks.firstIndex(of: artwork) {
            artworks.remove(at: index)
        }
    }
    
    public func fetchArtworks() throws {
        // No-op for preview
    }
}
