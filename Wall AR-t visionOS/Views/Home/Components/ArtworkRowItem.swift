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
        Group {
            VStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 220, height: 220)
                    .overlay {
                        Image(artwork.photoFileName)
                            .resizable()
                            .scaledToFit()
                    }
                    .padding([.top, .trailing, .leading], 12)
                VStack(alignment: .leading) {
                    Divider()
                    Text("\(artwork.title)", comment: "Artwork title")
                        .font(.title3)
                    HStack {
                        Text("by")
                            .foregroundStyle(.secondary)
                        Text(artwork.artist.name)
                    }
                    Text(formatPrice(artwork.price))
                }
                .padding(20)
            }
            .background(.ultraThinMaterial)
            .hoverEffect()
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .onTapGesture {
            navigationStore.push(.artWork(artwork))
        }
    }
}

#Preview {
    HomePage<PreviewArtworksStore>()
        .environmentObject(PreviewArtworksStore())
}
