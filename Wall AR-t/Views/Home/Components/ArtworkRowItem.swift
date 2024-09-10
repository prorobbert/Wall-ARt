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
                        Image(artwork.photoFileName)
                            .resizable()
                            .scaledToFit()
                    }
                VStack(alignment: .leading) {
                    Text(artwork.title)
                        .appFont(.title2)
                    HStack {
                        if !smallVersion {
                            Text("by")
                                .appFont(.subHeadline)
                                .foregroundStyle(Color.gray.opacity(0.5))
                            Text(artwork.artist.name)
                                .appFont(.subHeadline)
                            Spacer()
                        }
                        Text(formatPrice(artwork.price))
                            .appFont(.subHeadlineEmpasized)
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
