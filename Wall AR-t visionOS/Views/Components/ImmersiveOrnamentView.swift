//
//  ArtworkPlacementView.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 31/10/2024.
//

import ARDomain
import SwiftUI

struct ImmersiveOrnamentView: View {

    @EnvironmentObject var appState: AppState

    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.scenePhase) private var scenePhase

    @State private var presentConfirmationDialog = false
    var test = false

    var body: some View {
        HStack(spacing: 24) {
            VStack(spacing: 10) {
                Text("Currently placing:")
                if let filename = appState.selectedFileName {
                    Text(appState.placeableObjectByFileName[filename]?.descriptor.displayName ?? "None selected")
                } else {
                    Text("None selected")
                }
            }
            Button(
                appState.showObjectAttachments ? "Hide tooltips" : "Show tooltips",
                systemImage: appState.showObjectAttachments ? "eye.slash" : "eye"
            ) {
                Task {
                    appState.showObjectAttachments.toggle()
                }
            }
            .controlSize(.large)
            Button("Deselect artwork", systemImage: "xmark.circle") {
                Task {
                    await appState.deselectArtwork()
                }
            }
            .controlSize(.large)
            Menu {
                Button("remove_all_objects", systemImage: "trash") {
                    presentConfirmationDialog = true
                }

                Button("leave", systemImage: "xmark.circle") {
                    Task {
                        await dismissImmersiveSpace()
                        await appState.didLeaveImmersiveSpace()
                    }
                }
            } label: {
                Label("More actions", systemImage: "ellipsis.circle")
            }
            .controlSize(.large)
            .confirmationDialog(String(localized: "remove_all_objects_question"), isPresented: $presentConfirmationDialog) {
                Button("remove_all", role: .destructive) {
                    Task {
                        await appState.placementManager?.removeAllPlacedObjects()
                    }
                }
            }
        }
        .padding(20)
        .glassBackgroundEffect(
            in: RoundedRectangle(cornerRadius: 32, style: .continuous)
        )
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

#Preview {
    ImmersiveOrnamentView()
}
