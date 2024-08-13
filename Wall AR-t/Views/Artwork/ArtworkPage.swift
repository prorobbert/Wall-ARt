//
//  ArtworkPage.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 07/08/2024.
//

import SwiftUI
import Domain

struct ArtworkPage: View {
    var artwork: Artwork

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack {
                    Rectangle()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.gray.opacity(0.3))
                    VStack(alignment: .leading) {
                        Text(artwork.title)
                            .font(.title2)
                        HStack {
                            Text("by")
                            Text(artwork.artist.name)
                            Spacer()
                            Text(String(format: "€%.2f", artwork.price))
                                .fontWeight(.bold)
                        }
                    }
                }
                .frame(maxWidth: .infinity)

                VStack(alignment: .leading) {
                    Text("Description")
                        .fontWeight(.semibold)
                    Text(artwork.story)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                TabSelectionView(tabTitles: ["Details", "Tags", "Delivery"], content: { title in
                    switch title {
                    case "Details":
                        Text("Details tab")
                    case "Tags":
                        Text("Tags tab")
                    case "Delivery":
                        Text("Delivery tab")
                    default:
                        Text("Invalid tab title")
                    }
                })
            }
        }
        .trackScreen(Analytics(screen: .artwork, parameters: ["selected artwork": artwork.title]))
        .safeAreaPadding(.bottom, 20)
        .padding(.horizontal, 20)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    print("Pressed bookmark")
                } label: {
                    Image(systemName: "bookmark")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    print("Pressed like")
                } label: {
                    Image(systemName: "heart")
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ArtworkPage(artwork: Artwork.mockedPreview)
    }
}
