//
//  View+Extensions.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 05/08/2024.
//

import SwiftUI
import Domain

extension View {

    /// Analytics
    func trackEvent(_ analytics: Analytics) {
        EventModifier().track(analytics: analytics)
    }

    func trackScreen(_ analytics: Analytics) -> some View {
        return self.modifier(ScreenTrackingModifier(analytics: analytics))
    }

    @ViewBuilder
    func withPageDestination() -> some View {
        self.navigationDestination(for: Page.self) { destination in
            switch destination {
            case .artwork(let artwork):
                ArtworkPage(artwork: artwork)
                    .toolbar(.hidden, for: .tabBar)
            case .account:
                HomePage<RealArtworksStore>()
                    .toolbar(.hidden, for: .tabBar)
            }
        }
    }

    @ViewBuilder
    func redacted(reason: RedactionReasons = .placeholder, if condition: Bool) -> some View {
        if condition {
            self.redacted(reason: reason)
        } else {
            self
        }
    }
}
