//
//  HomePage.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 13/09/2024.
//

import ARDomain
import Domain
import SwiftUI

struct HomePage<Store: ArtworksStore>: View {
    @StateObject var navigationStore = NavigationStore()

    @EnvironmentObject var artworksStore: Store
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack(path: $navigationStore.path) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Text("Home page")
                    ArtworkRow(title: "Popular artworks", artworks: artworksStore.artworks)
                    ArtworkRow(title: "New artworks", artworks: artworksStore.artworks.shuffled())
                }
                .padding(60)
            }
            .scrollClipDisabled()
            .toolbarBackground(.hidden)
            .withPageDestination()
            .environmentObject(navigationStore)
        }
    }
}

#Preview {
    HomePage<PreviewArtworksStore>()
        .environmentObject(PreviewArtworksStore(numberOfArtworks: 5))
}
