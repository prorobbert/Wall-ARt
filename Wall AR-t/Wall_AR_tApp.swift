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
    @StateObject private var artworksStore: RealArtworksStore
    @StateObject private var artistsStore: RealArtistsStore
    @StateObject private var usersStore: RealUsersStore

    init() {
        let artworkDB = ArtworkDatabase()
        _artworksStore = StateObject(
            wrappedValue: RealArtworksStore(
                modelContext: artworkDB.modelContainer.mainContext
            )
        )
        _artistsStore = StateObject(
            wrappedValue: RealArtistsStore(
                modelContext: artworkDB.modelContainer.mainContext
            )
        )
        _usersStore = StateObject(
            wrappedValue: RealUsersStore(
                modelContext: artworkDB.modelContainer.mainContext
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView<RealArtworksStore>()
                .environmentObject(artworksStore)
                .environmentObject(artistsStore)
                .environmentObject(usersStore)
        }
    }
}
