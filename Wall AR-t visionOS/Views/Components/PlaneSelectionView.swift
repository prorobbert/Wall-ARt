//
//  PlaneSelectionView.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 13/06/2024.
//

import SwiftUI
import ARDomain

struct PlaneSelectionView: View {
    var appState: AppState

    var body: some View {
        VStack(spacing: 20) {
            Text("Select which plane to place objects on.")
            HStack {
                Button {
                    appState.detectVerticalPlanes.toggle()
                    Task {
                        await appState.updateSelectedFileNameAfterPlaneSwitch()
                    }
                } label: {
                    Text("Switch")
                }
                Spacer()
                Text(appState.detectVerticalPlanes ? "Vertical planes" : "Horizontal planes")
            }
        }
    }
}

#Preview(windowStyle: .plain) {
    struct Preview: View {
        @State var bool = false
        var body: some View {
            PlaneSelectionView(appState: AppState.previewAppState(selectedIndex: 1))
                .padding(20)
                .frame(width: 400)
                .glassBackgroundEffect()
        }
    }
    return Preview()
}
