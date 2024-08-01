//
//  PreviewArtistsStore.swift
//  Domain
//
//  Created by Robbert Ruiter on 01/08/2024.
//

import Combine
import Foundation
import SwiftData

public final class PreviewArtistsStore: ArtistsStore, ObservableObject {
    private let modelContext: ModelContext
    @Published public var artists: [Artist]

    @MainActor
    public init(modelContext: ModelContext? = nil, artists: [Artist] = .mockedPreview) {
        if let modelContext {
            self.modelContext = modelContext
        } else {
            let artworkDB = ArtworkDatabase(isStoredInMemoryOnly: true)
            self.modelContext = artworkDB.modelContainer.mainContext
        }
        self.artists = artists
    }

    public func addArtist() {
        artists.append(.mockedPreview)
    }

    public func deleteArtist(_ artist: Artist) {
        if let index = artists.firstIndex(of: artist) {
            artists.remove(at: index)
        }
    }

    public func fetchArtists() throws {
        // No-op for preview
    }

    public func getRandomArtist() throws -> Artist {
        return artists.randomElement()!
    }
}
