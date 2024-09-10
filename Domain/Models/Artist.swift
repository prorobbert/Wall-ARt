//
//  Artist.swift
//  Domain
//
//  Created by Robbert Ruiter on 01/08/2024.
//

import Foundation
import SwiftData

@Model
public class Artist: Identifiable, Equatable {
    @Attribute(.unique) public var id: UUID
    public var personalInfo: String
    public var user: User
    @Relationship(deleteRule: .cascade)
    public var artworks: [Artwork]

    public init(
        personalInfo: String,
        user: User,
        artworks: [Artwork] = []
    ) {
        self.id = UUID()
        self.personalInfo = personalInfo
        self.user = user
        self.artworks = artworks
    }

    public var name: String {
        return user.name
    }
}

public extension Artist {
    static var mockedPreview: Artist {
        return Artist(
            personalInfo: "The first artist ever",
            user: .mockedPreview
        )
    }
}

public extension Array where Element == Artist {
    static var mockedPreview: Self {
        return [
            Artist(
                personalInfo: "I only pain using my toes",
                user: .mockedPreview
            ),
            Artist(
                personalInfo: "Creating stuff with AI makes me an artist too, right?",
                user: .mockedPreview
            )
        ]
    }
}
