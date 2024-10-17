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
        loadMockData()
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

    private func loadMockData() {
        var user = User.mockedPreview
        modelContext.insert(user)
        do {
            user = try modelContext.fetch(FetchDescriptor<User>(sortBy: [SortDescriptor(\.firstName)]))[0]
        } catch {}

        let tempArtist = Artist.mockedPreview
        var artist = Artist(personalInfo: tempArtist.personalInfo, user: user)
        modelContext.insert(artist)
        do {
            artist = try modelContext.fetch(FetchDescriptor<Artist>(sortBy: [SortDescriptor(\.user.firstName)]))[0]
        } catch {}

        var delivery = Delivery.mockedPreview
        modelContext.insert(delivery)
        do {
            delivery = try modelContext.fetch(FetchDescriptor<Delivery>())[0]
        } catch {}

        var tags: [Tag] = [Tag(title: "Bird"), Tag(title: "Animal"), Tag(title: "Wildlife")]
        for tag in tags {
            modelContext.insert(tag)
        }
        do {
            tags = try modelContext.fetch(FetchDescriptor<Tag>())
        } catch {
            tags = []
        }

        for artwork in artworks {
            let newArtwork = Artwork(
                title: artwork.title,
                story: artwork.story,
                medium: Medium(rawValue: artwork.medium)!,
                price: artwork.price,
                width: artwork.width,
                height: artwork.height,
                depth: artwork.depth,
                subject: "Animals and birds",
                style: "Photorealistic",
                edition: .oneOfAkind,
                artist: artist,
                deliveryDetails: delivery,
                tags: tags,
                photoFileName: "Hand_Painting",
                modelFileName: "Hand_Painting"
            )
            modelContext.insert(newArtwork)
        }
        do {
            artworks = try modelContext.fetch(FetchDescriptor<Artwork>(sortBy: [SortDescriptor(\.title)]))
        } catch {}
    }
}
