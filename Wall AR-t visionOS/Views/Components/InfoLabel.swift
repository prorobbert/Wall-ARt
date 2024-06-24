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
            return String(localized: "functionality_not_supported_in_simulator")
        } else if !appState.allRequiredAuthorizationsAreGranted {
            return String(localized: "missing_necessary_authorisations")
        } else {
            return String(localized: "infolabel_success_message")
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
