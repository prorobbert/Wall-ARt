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

    public init(title: String) {
        self.id = UUID()
        self.title = title
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
            Tag(title: "Ara parrot")
        ]
    }
}
