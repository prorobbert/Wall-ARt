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
    public init(modelContext: ModelContext? = nil, numberOfArtworks: Int = 3) {
        if let modelContext {
            self.modelContext = modelContext
        } else {
            let artworkDB = ArtworkDatabase(isStoredInMemoryOnly: true)
            self.modelContext = artworkDB.modelContainer.mainContext
        }
        self.artworks = []
        loadMockData(numberOfArtworks: numberOfArtworks)
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
            subject: "Animals and birds",
            style: "Photorealistic",
            edition: .oneOfAkind,
            artist: Artist.mockedPreview,
            photoFileName: "Hand_Painting",
            modelFileName: "Hand_Painting"
        )
        artworks.append(artwork)
    }

    public func deleteArtwork(_ artwork: Artwork) {
        if let index = artworks.firstIndex(of: artwork) {
            artworks.remove(at: index)
        }
    }

    public func reloadSampleData(artists: [Artist], tags: [Tag]) throws {}

    private func loadMockData(numberOfArtworks: Int) {
        let user = User.mockedPreview

        let artist = Artist.mockedPreview
        artist.user = user

        let delivery = Delivery.mockedPreview

        let tags: [Tag] = [Tag(title: "Bird"), Tag(title: "Animal"), Tag(title: "Wildlife")]

        for _ in 0..<numberOfArtworks {
            let medium = Medium.allCases.randomElement() ?? .oilOnCanvas
            let randomPhotoName = Artwork.randomPhotoName
            let newArtwork = Artwork(
                title: Artwork.randomTitle,
                story: Artwork.randomStory,
                medium: medium,
                price: generateRandomPrice(),
                width: 300,
                height: 500,
                depth: 20,
                subject: "Animals and birds",
                style: "Photorealistic",
                edition: .oneOfAkind,
                artist: artist,
                deliveryDetails: delivery,
                tags: tags,
                photoFileName: randomPhotoName,
                modelFileName: randomPhotoName
            )
            self.artworks.append(newArtwork)
        }
    }
}
