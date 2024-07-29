//
//  ArtworkDatabase.swift
//  Domain
//
//  Created by Robbert Ruiter on 26/07/2024.
//

import SwiftData

public struct ArtworkDatabase {
    public let modelContainer: ModelContainer
    
    public init(isStoredInMemoryOnly: Bool = false) {
        let modelConfiguration = ModelConfiguration(
            isStoredInMemoryOnly: isStoredInMemoryOnly
        )
        self.modelContainer = try! ModelContainer(
            for: Artwork.self,
            configurations: modelConfiguration
        )
    }
}
