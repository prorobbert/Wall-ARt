//
//  Wall_AR_t_visionOSApp.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 11/06/2024.
//

import SwiftUI
import ARKit
import ARDomain

private enum UIIdentifier {
    static let immersiveSpace = "Object Placement"
}

@main
struct Wall_AR_t_visionOSApp: App {
    
    @State private var appState = AppState()
    @State private var modelLoader = ModelLoader()
    
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.scenePhase) private var scenePhase
    
    @MainActor
    private func setupModelLoader() {
        modelLoader = ModelLoader()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(appState: appState, modelLoader: modelLoader, immersiveSpaceIdentifier: UIIdentifier.immersiveSpace)
                .task {
//                    setupModelLoader()
                    await modelLoader.loadObjects()
                    appState.setPlaceableObjects(modelLoader.placeableObjects)
                }
        }
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
