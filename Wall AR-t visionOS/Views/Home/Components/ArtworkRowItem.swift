//
//  ArtworkRowItem.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 16/10/2024.
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
            navigationStore.push(.artWork(artwork))
        } label: {
            VStack(alignment: .leading, spacing: 8) {
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
                    HStack {
                        if !smallVersion {
                            Text("by")
                                .foregroundStyle(Color.gray.opacity(0.5))
                            Text(artwork.artist.name)
                            Spacer()
                        }
                        Text(formatPrice(artwork.price))
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
