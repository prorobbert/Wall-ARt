//
//  HomePage.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 05/08/2024.
//

import Domain
import SwiftUI

struct HomePage<Store: ArtworksStore>: View {
    @StateObject var navigationStore = NavigationStore()
    @EnvironmentObject var artworksStore: Store

    var body: some View {
        NavigationStack(path: $navigationStore.path) {
            Text("greeting")
            List(artworksStore.artworks) { artwork in
                artworkListItem(for: artwork)

            }
            .withPageDestination()
            .trackScreen(Analytics(screen: .home))
        }
    }
}

private extension HomePage {
    @ViewBuilder
    func artworkListItem(for artwork: Artwork) -> some View {
        PageLink(.artwork(artwork)) {
            VStack {
                Text(artwork.title)
                Text(Medium(rawValue: artwork.medium)!.label)
            }
        }
    }
}

#Preview {
    HomePage<PreviewArtworksStore>()
        .environmentObject(PreviewArtworksStore())
}
