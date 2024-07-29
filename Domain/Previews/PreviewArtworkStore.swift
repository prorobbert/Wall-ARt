//
//  PreviewArtworkStore.swift
//  Domain
//
//  Created by Robbert Ruiter on 29/07/2024.
//

import Foundation

public final class PreviewArtworkStore: ArtworksRepository {
    public let artworks: [Artwork]

    public init(artworks: [Artwork] = []) {
        self.artworks = artworks
    }

    public func addArtwork() {}

    public func deleteArtwork(_ artwork: Artwork) {}

    public func fetchArtworks() {}
}
