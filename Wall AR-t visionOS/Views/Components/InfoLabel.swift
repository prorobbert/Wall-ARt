//
//  InfoLabel.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 13/06/2024.
//

import SwiftUI
import ARDomain

struct InfoLabel: View {
    let appState: AppState

    var body: some View {
        Text(infoMessage)
            .font(.subheadline)
            .multilineTextAlignment(.center)
    }
    var infoMessage: String {
        if !appState.allRequiredProvidersAreSupported {
            return "This app requires functionality that isn't supported in Simulator."
        } else if !appState.allRequiredAuthorizationsAreGranted {
            return "This app is missing necessary authorizations, You can change this in Settings > Privacy & Security."
        } else {
            return """
Place and move 3D models in your physical environment. The system maintains their placement across app launches.
"""
        }
    }
}

#Preview(windowStyle: .plain) {
    InfoLabel(appState: AppState.previewAppState())
        .frame(width: 300)
        .padding(.horizontal, 40.0)
        .padding(.vertical, 20.0)
        .glassBackgroundEffect()
}
