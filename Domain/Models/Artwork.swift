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
    public var medium: Medium
    public var price: Double
    public var width: Int // In millimeter
    public var height: Int // In millimeter
    public var depth: Int // In millimeter
    public var isAvailable: Bool
    public var artist: Artist

    public init(
        title: String,
        story: String,
        medium: Medium,
        price: Double,
        width: Int,
        height: Int,
        depth: Int,
        artist: Artist,
        isAvailable: Bool = false
    ) {
        self.id = UUID()
        self.title = title
        self.story = story
        self.medium = medium
        self.price = price
        self.height = height
        self.width = width
        self.depth = depth
        self.artist = artist
        self.isAvailable = isAvailable
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
                artist: .mockedPreview
            ),
            Artwork(
                title: "Solitude's Embrace",
                story: "Another beautiful piece of art.",
                medium: .watercolorOnPaper,
                price: 274.95,
                width: 600,
                height: 800,
                depth: 25,
                artist: .mockedPreview,
                isAvailable: true
            ),
            Artwork(
                title: "Mystic Pathways",
                story: "Yet another beautiful piece of art.",
                medium: .acrylicOnCanvas,
                price: 2775.0,
                width: 700,
                height: 1050,
                depth: 20,
                artist: .mockedPreview
            )
        ]
    }
}
