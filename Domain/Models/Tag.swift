//
//  Tag.swift
//  Domain
//
//  Created by Robbert Ruiter on 13/08/2024.
//

import Foundation
import SwiftData

@Model
public class Tag: Identifiable, Equatable {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var size: CGFloat = 0
    public var artworks: [Artwork]?

    public init(title: String, artworks: [Artwork] = []) {
        self.id = UUID()
        self.title = title
        self.artworks = artworks
    }
}

public extension Array where Element == Tag {
    static var mockedPreview: Self {
        return [
            Tag(title: "Forrest"),
            Tag(title: "Bird"),
            Tag(title: "Animal"),
            Tag(title: "Wildlife"),
            Tag(title: "Jungle"),
            Tag(title: "Parrot"),
            Tag(title: "Ara parrot"),
            Tag(title: "Green leaves"),
            Tag(title: "Colorful")
        ]
    }
}
