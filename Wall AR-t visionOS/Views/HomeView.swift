//
//  HomeView.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 13/06/2024.
//

import SwiftUI
import ARKit
import ARDomain

struct HomeView: View {
    let appState: AppState
    let modelLoader: ModelLoader
    let immersiveSpaceIdentifier: String

    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("object_placement")
                    .font(.title)

                InfoLabel(appState: appState)
                    .padding(.horizontal, 30)
                    .frame(width: 400)
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)

                Group {
                    if !modelLoader.didFinishLoading {
                        VStack(spacing: 10) {
                            Text("loading_models")
                            ProgressView(value: modelLoader.progress)
                                .frame(maxWidth: 200)
                        }
                    } else if !appState.immersiveSpaceOpened {
                        Button("enter") {
                            Task {
                                switch await openImmersiveSpace(id: immersiveSpaceIdentifier) {
                                case .opened:
                                    break
                                case .error:
                                    print("An error occurred when trying to open the immersive space: \(immersiveSpaceIdentifier)")
                                case .userCancelled:
                                    print("The user declined opening immersive space \(immersiveSpaceIdentifier)")
                                @unknown default:
                                    break
                                }
                            }
                        }
                        .disabled(!appState.canEnterImmersiveSpace)
                    }
                }
                .padding(.top, 10)
            }
            .padding(.vertical, 24)
            .glassBackgroundEffect()

            if appState.immersiveSpaceOpened {
                ObjectPlacementMenuView(appState: appState)
                    .padding(20)
                    .glassBackgroundEffect()
            }
        }
        .fixedSize()
        .onChange(of: scenePhase, initial: true) {
            if scenePhase == .active {
                Task {
                    // Check whether authorization has changed when the user brings the app to the foreground.
                    await appState.queryWorldSensingAuthorization()
                }
            } else {
                // Leave the immersive space if this view is no longer active;
                // the controls in this view pair up with the immersice space to drive the placement experience.
                if appState.immersiveSpaceOpened {
                    Task {
                        await dismissImmersiveSpace()
                        await appState.didLeaveImmersiveSpace()
                    }
                }
            }
        }
        .onChange(of: appState.providersStoppedWithError, { _, providersStoppedWithError in
            // Immediately close the immersive space if there was an error.
            if providersStoppedWithError {
                if appState.immersiveSpaceOpened {
                    Task {
                        await dismissImmersiveSpace()
                        await appState.didLeaveImmersiveSpace()
                    }
                }

                appState.providersStoppedWithError = false
            }
        })
        .task {
            // Request authorization before the user attempts to open the immersive space;
            // this gives the app the opportunity to respond gracefully if authorization isn't granted.
            if appState.allRequiredProvidersAreSupported {
                await appState.requestWorldSensingAuthorization()
            }
        }
        .task {
            // Monitors changes in authorization. For example, the user may revoke authorization in Settings.
            await appState.monitorSessionEvents()
        }
    }
}

//#Preview(windowStyle: .plain) {
//    HStack {
//        VStack {
//            HomeView(appState: AppState.previewAppState(),
//                     modelLoader: ModelLoader(progress: 0.5),
//                     immersiveSpaceIdentifier: "A")
//            HomeView(appState: AppState.previewAppState(),
//                     modelLoader: ModelLoader(progress: 1.0),
//                     immersiveSpaceIdentifier: "A")
//        }
//        VStack {
//            HomeView(appState: AppState.previewAppState(immersiveSpaceOpened: true),
//                     modelLoader: ModelLoader(progress: 1.0),
//                     immersiveSpaceIdentifier: "A")
//        }
//    }
//}
