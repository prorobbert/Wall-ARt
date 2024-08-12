//
//  ArtworkRowItem.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 12/08/2024.
//

import Domain
import SwiftUI

struct ArtworkRowItem: View {
    let artwork: Artwork

    @EnvironmentObject var navigationStore: NavigationStore

    var body: some View {
        Button {
            trackEvent(.init(event: .artworkDetails, parameters: ["id": artwork.id.uuidString]))

            navigationStore.push(.artwork(artwork))
        } label: {
            VStack(alignment: .leading, spacing: 8.0) {
                Rectangle()
                    .frame(width: 220, height: 220)
                    .foregroundStyle(Color.gray)
                VStack(alignment: .leading) {
                    Text(artwork.title)
                        .font(.title3)
                    HStack {
                        Text("by")
                        Text(artwork.artist.name)
                        Spacer()
                        Text(String(format: "€%.2f", artwork.price))
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomePage<PreviewArtworksStore>()
        .environmentObject(PreviewArtworksStore())
}
