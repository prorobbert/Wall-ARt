//
//  PreviewArtworkStore.swift
//  Domain
//
//  Created by Robbert Ruiter on 29/07/2024.
//

import Foundation
import Combine

public final class PreviewArtworkStore: ArtworksRepository, ObservableObject {
    @Published public var artworks: [Artwork]

    public init(artworks: [Artwork]) {
        self.artworks = artworks
        print("Initialized PreviewArtworkStore with artworks: \(artworks.map { $0.title })")
    }
    
    public func addArtwork() {
        let artwork = Artwork(title: "Preview Artwork")
        artworks.append(artwork)
        print("Added artwork: \(artwork.title)")
    }
    
    public func deleteArtwork(_ artwork: Artwork) {
        if let index = artworks.firstIndex(of: artwork) {
            artworks.remove(at: index)
            print("Deleted artwork: \(artwork.title)")
        }
    }
    
    public func fetchArtworks() throws {
        // No-op for preview
    }
}
