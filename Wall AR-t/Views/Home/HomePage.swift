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
            ScrollView {
                LazyVStack(alignment: .leading, content: {
                    ForEach(artworksStore.artworks, id: \.self) { artwork in
                        ArtworkRow(artwork: artwork)
                    }
                })
            }
            .withPageDestination()
            .trackScreen(Analytics(screen: .home))
        }
    }
}

struct ArtworkRow: View {
    let artwork: Artwork

    var body: some View {
        PageLink(.artwork(artwork)) {
            VStack(alignment: .leading, spacing: 8.0) {
                VStack {
                    Text(artwork.title)
                    Text(Medium(rawValue: artwork.medium)!.label)
                }
                .padding(.vertical, 16.0)

                Divider()
            }
        }
    }
}

#Preview {
    HomePage<PreviewArtworksStore>()
        .environmentObject(PreviewArtworksStore())
}
