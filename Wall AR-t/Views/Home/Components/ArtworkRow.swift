//
//  ArtworkRow.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 12/08/2024.
//

import SwiftUI
import Domain

struct ArtworkRow: View {
    let title: String
    let artworks: [Artwork]

    @EnvironmentObject var navigationStore: NavigationStore

    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .bottom) {
                Text(title)
                    .appFont(.body)
                Spacer()
                Button {
                    trackEvent(.init(event: .artworkList, parameters: ["List name": title]))

                    navigationStore.push(.artworkList(listTitle: title))
                } label: {
                    Text("View all")
                        .appFont(.caption1)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .frame(maxWidth: .infinity)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(artworks, id: \.self) { artwork in
                        ArtworkRowItem(artwork: artwork)
                    }
                }
            }
        }
    }
}

#Preview {
    HomePage<PreviewArtworksStore>()
        .environmentObject(PreviewArtworksStore())
}
