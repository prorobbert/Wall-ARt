//
//  Wall_AR_t_visionOSApp.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 11/06/2024.
//

import Domain
import SwiftUI
import ARKit
import ARDomain

private enum UIIdentifier {
    static let immersiveSpace = "Object Placement"
}

@main
struct WallARtVisionOSApp: App {

    @State private var appState = AppState()
    @State private var modelLoader = ModelLoader()
    @StateObject var navigationStore = NavigationStore()
    @StateObject private var artworkStore: RealArtworksStore

    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.scenePhase) private var scenePhase

    @MainActor
    private func setupModelLoader() {
        modelLoader = ModelLoader()
    }

    init() {
        let artworkDB = ArtworkDatabase()
        _artworkStore = StateObject(wrappedValue: RealArtworksStore(modelContext: artworkDB.modelContainer.mainContext))
    }

    var body: some Scene {
        WindowGroup {
            TabBar()
                .environmentObject(navigationStore)
                .environmentObject(artworkStore)
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
