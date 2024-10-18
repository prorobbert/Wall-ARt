//
//  View+Extensions.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 16/10/2024.
//

import Domain
import SwiftUI

extension View {
    @ViewBuilder
    func withPageDestination() -> some View {
        self.navigationDestination(for: Page.self) { destination in
            switch destination {
            case .artWork(let artwork):
                ArtworkPage(artwork: artwork)
            case .artworkList(let listTitle):
                ArtworkListPage(title: listTitle)
            case .account:
                HomePage<RealArtworksStore>()
            }
        }
    }
}
