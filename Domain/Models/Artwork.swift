//
//  Artwork.swift
//  Domain
//
//  Created by Robbert Ruiter on 11/06/2024.
//

import Foundation
import SwiftData

@Model
public class Artwork: Identifiable, Equatable {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var story: String // A stored property cannot be named 'description'. So renamed it to 'story'
    public var medium: Medium.RawValue
    public var price: Double
    public var width: Int // In millimeter
    public var height: Int // In millimeter
    public var depth: Int // In millimeter
    public var subject: String
    public var style: String
    public var edition: ArtworkEdition.RawValue
    public var isAvailable: Bool
    @Relationship(inverse: \Artist.artworks)
    public var artist: Artist
    public var deliveryDetails: Delivery?
    @Relationship(inverse: \Tag.artworks) public var tags: [Tag]?
    public var photoFileName: String
    public var modelFileName: String
    public var canBePlacedOn: CanBePlacedOn.RawValue

    @Attribute(.externalStorage)
    public var photos: [Data]?

    public init(
        title: String,
        story: String,
        medium: Medium,
        price: Double,
        width: Int,
        height: Int,
        depth: Int,
        subject: String,
        style: String,
        edition: ArtworkEdition,
        artist: Artist,
        deliveryDetails: Delivery? = nil,
        tags: [Tag] = [],
        isAvailable: Bool = false,
        photoFileName: String,
        modelFileName: String,
        canBePlacedOn: CanBePlacedOn = .vertical
    ) {
        self.id = UUID()
        self.title = title
        self.story = story
        self.medium = medium.rawValue
        self.price = price
        self.height = height
        self.width = width
        self.depth = depth
        self.subject = subject
        self.style = style
        self.edition = edition.rawValue
        self.artist = artist
        self.deliveryDetails = deliveryDetails
        self.tags = tags
        self.isAvailable = isAvailable
        self.photoFileName = photoFileName
        self.modelFileName = modelFileName
        self.canBePlacedOn = canBePlacedOn.rawValue
    }

    public var dimensions: (DimensionUnit) -> String {
        return { unit in
            switch unit {
            case .centimeters:
                let widthCM = Double(self.width) / 10.0
                let heightCM = Double(self.height) / 10.0
                let depthCM = Double(self.depth) / 10.0
                return "\(formatDimension(widthCM)) x \(formatDimension(heightCM)) x \(formatDimension(depthCM)) cm"
            case .inches:
                let widthInches = Double(self.width) / 25.4
                let heightInches = Double(self.height) / 25.4
                let depthInches = Double(self.depth) / 25.4
                return "\(formatDimension(widthInches)) x \(formatDimension(heightInches)) x \(formatDimension(depthInches)) in"
            }
        }
    }
}

public extension Array where Element == Artwork {
    static var mockedPreview: Self {
        return [
            Artwork(
                title: "Ethereal Whispers",
                story: "A beautiful piece of art.",
                medium: .oilOnCanvas,
                price: 123.0,
                width: 300,
                height: 500,
                depth: 20,
                subject: "Animals and birds",
                style: "Photorealistic",
                edition: .oneOfAkind,
                artist: .mockedPreview,
                tags: .mockedPreview,
                photoFileName: "Hand_Painting",
                modelFileName: "Hand_Painting"
            ),
            Artwork(
                title: "Solitude's Embrace",
                story: "Another beautiful piece of art.",
                medium: .watercolorOnPaper,
                price: 274.95,
                width: 600,
                height: 800,
                depth: 25,
                subject: "Animals and birds",
                style: "Photorealistic",
                edition: .limitedSeries,
                artist: .mockedPreview,
                tags: .mockedPreview,
                isAvailable: true,
                photoFileName: "Monumental_Figure",
                modelFileName: "Monumental_Figure"
            ),
            Artwork(
                title: "Mystic Pathways",
                story: "Yet another beautiful piece of art.",
                medium: .acrylicOnCanvas,
                price: 2775.0,
                width: 700,
                height: 1050,
                depth: 20,
                subject: "Animals and birds",
                style: "Photorealistic",
                edition: .oneOfAkind,
                artist: .mockedPreview,
                tags: .mockedPreview,
                photoFileName: "Trees_with_water",
                modelFileName: "Trees_with_water"
            )
        ]
    }
}

public extension Artwork {
    static var mockedPreview: Artwork {
        return Artwork(
            title: "Ethereal Whispers",
            story: "A beautiful piece of art.",
            medium: .oilOnCanvas,
            price: 123.0,
            width: 300,
            height: 500,
            depth: 20,
            subject: "Animals and birds",
            style: "Photorealistic",
            edition: .oneOfAkind,
            artist: .mockedPreview,
            deliveryDetails: .mockedPreview,
            tags: .mockedPreview,
            photoFileName: "Hand_Painting",
            modelFileName: "Hand_Painting"
        )
    }

    static var randomTitle: String {
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
        return artworkTitles.randomElement()!
    }

    static var randomStory: String {
        let artworkStories = [
            "A beautiful piece of art.",
            "Another beautiful piece of art.",
            "Yet another beautiful piece of art.",
            "Some pretty things on a canvas",
            "I dreamed about this and wanted to bring it to life. That's why it's here right now. Neat, huh?"
        ]
        return artworkStories.randomElement()!
    }

    static var randomPhotoName: String {
        let artworkPhotoNames = [
            "Hands_Painting",
            "Monumental_Figure",
            "Sunset_Canvas",
            "Sunset_Painting",
            "Trees_with_water",
            "KingFisherSplash"
        ]
        return artworkPhotoNames.randomElement()!
    }
}
