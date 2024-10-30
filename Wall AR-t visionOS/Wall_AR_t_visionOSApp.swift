//
//  Wall_AR_t_visionOSApp.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 11/06/2024.
//

import Domain
import Infuse
import SwiftUI
import ARKit
import ARDomain

@main
struct WallARtVisionOSApp: App {

    @StateObject private var appState: AppState

    @StateObject var navigationStore = NavigationStore()
    @StateObject private var artworkStore: RealArtworksStore
    @StateObject private var artistsStore: RealArtistsStore
    @StateObject private var usersStore: RealUsersStore
    @StateObject private var tagsStore: RealTagsStore

    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.scenePhase) private var scenePhase

//    @MainActor
//    private func setupModelLoader() {
//        modelLoader = ModelLoader()
//    }

    init() {
        let artworkDB = ArtworkDatabase()
        _artworkStore = StateObject(
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
        _tagsStore = StateObject(
            wrappedValue: RealTagsStore(
                modelContext: artworkDB.modelContainer.mainContext
            )
        )
        Dependencies.shared.setup()

        _appState = StateObject(wrappedValue: AppState())
    }

    var body: some Scene {
        WindowGroup {
            TabBar()
                .environmentObject(navigationStore)
                .environmentObject(appState)
                .environmentObject(artworkStore)
                .environmentObject(artistsStore)
                .environmentObject(usersStore)
                .environmentObject(tagsStore)
        }
//        WindowGroup {
//            HomeView(
//                appState: appState,
//                modelLoader: modelLoader,
//                immersiveSpaceIdentifier: UIIdentifier.immersiveSpace
//            )
//                .task {
////                    setupModelLoader()
//                    await modelLoader.loadObjects()
//                    appState.setPlaceableObjects(modelLoader.placeableObjects)
//                }
//        }
        .windowResizability(.contentSize)
        .windowStyle(.plain)

        ImmersiveSpace(id: UIIdentifier.immersiveSpace) {
            ObjectPlacementRealityView(appState: appState)
        }
        .onChange(of: scenePhase, initial: true) {
            if scenePhase != .active {
                // Close the immersive space when the user dismisses the application.
                if appState.immersiveSpaceOpened {
                    Task {
                        await dismissImmersiveSpace()
                        appState.didLeaveImmersiveSpace()
                    }
                }
            }
        }
    }
}
