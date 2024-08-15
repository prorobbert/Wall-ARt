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
    let smallVersion: Bool

    @EnvironmentObject var navigationStore: NavigationStore

    init(artwork: Artwork, smallVersion: Bool = false) {
        self.artwork = artwork
        self.smallVersion = smallVersion
    }

    var body: some View {
        Button {
            trackEvent(.init(event: .artworkDetails, parameters: ["id": artwork.id.uuidString]))

            navigationStore.push(.artwork(artwork))
        } label: {
            VStack(alignment: .leading, spacing: 8.0) {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: smallVersion ? 150 : 220, height: smallVersion ? 150 : 220)
                    .overlay {
                        Image("KingFisher")
                            .resizable()
                            .scaledToFit()
                    }
                VStack(alignment: .leading) {
                    Text(artwork.title)
                        .font(.title3)
                    HStack {
                        if !smallVersion {
                            Text("by")
                            Text(artwork.artist.name)
                            Spacer()
                        }
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
