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
    @StateObject private var artworkStore: ArtworksStore
    
    init() {
        let artworkDB = ArtworkDatabase()
        _artworkStore = StateObject(wrappedValue: ArtworksStore(modelContext: artworkDB.modelContainer.mainContext))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(artworkStore)
        }
    }
}
