//
//  ObjectPlacementMenuView.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 13/06/2024.
//

import SwiftUI
import ARDomain

struct ObjectPlacementMenuView: View {
    var appState: AppState
    
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    @State private var presentConfirmationDialog = false
    
    var body: some View {
        VStack(spacing: 20) {
            PlaneSelectionView(appState: appState)
            ObjectSelectionView(
                modelDescriptors: appState.filteredModelDescriptors,
                selectedFileName: appState.selectedFileName
            ) { descriptor in
                if let model = appState.placeableObjectByFileName[descriptor.fileName] {
                    print("selecting new model: \(model.descriptor)")
                    appState.placementManager?.select(model)
                }
            }
            
            
            Button("Remove all objects", systemImage: "trash") {
                presentConfirmationDialog = true
            }
            .font(.subheadline)
            .buttonStyle(.borderless)
            .confirmationDialog("Remove all objects?", isPresented: $presentConfirmationDialog) {
                Button("Remove all", role: .destructive) {
                    Task {
                        await appState.placementManager?.removeAllPlacedObjects()
                    }
                }
            }

            Button("Leave", systemImage: "xmark.circle") {
                Task {
                    await dismissImmersiveSpace()
                    appState.didLeaveImmersiveSpace()
                }
            }
            .font(.subheadline)
            .buttonStyle(.borderless)
        }
    }
}

#Preview(windowStyle: .plain) {
    ObjectPlacementMenuView(appState: AppState.previewAppState(selectedIndex: 1))
        .padding(20)
        .frame(width: 400)
        .glassBackgroundEffect()
}
