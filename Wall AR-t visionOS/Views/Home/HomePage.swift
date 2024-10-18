//
//  HomePage.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 13/09/2024.
//

import Domain
import SwiftUI

struct HomePage<Store: ArtworksStore>: View {
    @StateObject var navigationStore = NavigationStore()

    @EnvironmentObject var artworksStore: Store

    var body: some View {
        NavigationStack(path: $navigationStore.path) {
            Text("Home page")
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    ArtworkRow(title: "Popular artworks", artworks: artworksStore.artworks)
                }
            }
            .withPageDestination()
            .environmentObject(navigationStore)
        }
        .padding(24)
    }
}

#Preview {
    HomePage<PreviewArtworksStore>()
        .environmentObject(PreviewArtworksStore())
}
