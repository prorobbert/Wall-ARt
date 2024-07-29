//
//  Wall_AR_tApp.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 11/06/2024.
//

import Domain
import SwiftUI

@main
struct WallARtApp: App {
    private let artworkDB: ArtworkDatabase
    
    init() {
        artworkDB = ArtworkDatabase()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                artworkStore: ArtworksStore(
                    modelContext: artworkDB.modelContainer.mainContext
                )
            )
        }
    }
}
