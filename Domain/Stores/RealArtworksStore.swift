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
        do {
            try fetchedResultsController.fetch()
        } catch {}
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
            subject: "Animals and birds",
            style: "Photorealistic",
            edition: .oneOfAkind,
            artist: artist,
            photoFileName: "Trees_with_water",
            modelFileName: "Trees_with_water"
        )
        modelContext.insert(artwork)
    }

    public func deleteArtwork(_ artwork: Artwork) {
        modelContext.delete(artwork)
    }

    public func reloadSampleData(artists: [Artist], tags: [Tag]) {
        do {
            try modelContext.delete(model: Artwork.self)
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
            let artworkStories = [
                "A beautiful piece of art.",
                "Another beautiful piece of art.",
                "Yet another beautiful piece of art.",
                "Some pretty things on a canvas",
                "I dreamed about this and wanted to bring it to life. That's why it's here right now. Neat, huh?"
            ]
            let artworkPhotoNames = [
                "Hand_Painting",
                "Monumental_Figure",
                "Sunset_Canvas",
                "Sunset_Painting",
                "Trees_with_water",
                "KingFisherSplash"
            ]
            let delivertCountries = [
                "France",
                "Netherlands",
                "Belgium",
                "United Kingdom",
                "Germany",
                "Italy"
            ]
            for _ in 1...12 {
                let delivery = Delivery(
                    shippingFrom: delivertCountries.randomElement()!,
                    price: generateRandomPrice(range: 8.5...35.0, randomizeDecimals: false, skewToLowerValues: false),
                    shippingDuration: 3
                )
                let randomNumber = Int.random(in: 2...6)
                let selectedTags = Array(tags.shuffled().prefix(randomNumber))
                let randomPhotoName = artworkPhotoNames.randomElement()!
                let artwork = Artwork(
                    title: artworkTitles.randomElement()!,
                    story: artworkStories.randomElement()!,
                    medium: Medium.allCases.randomElement()!,
                    price: generateRandomPrice(),
                    width: 300,
                    height: 500,
                    depth: 20,
                    subject: "Animals and birds",
                    style: "Photorealistic",
                    edition: ArtworkEdition.allCases.randomElement()!,
                    artist: artists.randomElement()!,
                    deliveryDetails: delivery,
                    photoFileName: randomPhotoName,
                    modelFileName: randomPhotoName
                )
                modelContext.insert(artwork)
                artwork.tags = selectedTags
            }
            try fetchedResultsController.fetch()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
