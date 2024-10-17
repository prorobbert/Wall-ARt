//
//  ArtworkRow.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 16/10/2024.
//

import Domain
import SwiftUI

struct ArtworkRow: View {
    let title: String
    let artworks: [Artwork]

    @EnvironmentObject var navigationStore: NavigationStore

    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text(title)
                Spacer()
                Button {
                    navigationStore.push(.artworkList(listTitle: title))
                } label: {
                    Text("View all")
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
