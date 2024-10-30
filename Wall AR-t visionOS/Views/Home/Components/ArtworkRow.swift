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
        VStack(spacing: 20) {
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(artworks, id: \.self) { artwork in
                            ArtworkRowItem(artwork: artwork)
                        }
                    }
                }
            } header: {
                Text(title)
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
        }
    }
}

#Preview {
    HomePage<PreviewArtworksStore>()
        .environmentObject(PreviewArtworksStore())
}
