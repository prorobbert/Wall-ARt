//
//  ArtworkDatabase.swift
//  Domain
//
//  Created by Robbert Ruiter on 26/07/2024.
//

import SwiftData
import Foundation

public struct ArtworkDatabase {
    public let modelContainer: ModelContainer

    @MainActor
    public init(isStoredInMemoryOnly: Bool = false) {
        let modelConfiguration = ModelConfiguration(
            isStoredInMemoryOnly: isStoredInMemoryOnly
        )
        do {
            self.modelContainer = try ModelContainer(
                for: Artwork.self,
                configurations: modelConfiguration
            )
        } catch {
            print(error)
            fatalError()
        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
