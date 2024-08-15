//
//  ArtworkPage.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 07/08/2024.
//

import Domain
import SwiftUI

struct ArtworkPage: View {
    var artwork: Artwork

    @State private var showingAR = false

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
                            Text(formatPrice(artwork.price))
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
                        VStack(alignment: .leading) {
                            HStack {
                                Text("•")
                                Text(ArtworkEdition(rawValue: artwork.edition)!.label)
                            }
                            HStack {
                                Text("•")
                                Text(Medium(rawValue: artwork.medium)!.label)
                            }
                            HStack {
                                Text("•")
                                Text("Size: \(artwork.dimensions(.centimeters))")
                            }
                            HStack {
                                Text("•")
                                Text("Style: \(artwork.style)")
                            }
                            HStack {
                                Text("•")
                                Text("Subject: \(artwork.subject)")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    case "Tags":
                        if let tags = artwork.tags, !tags.isEmpty {
                            ArtworkTags(tags: tags)
                        } else {
                            ContentUnavailableView {
                                Image(systemName: "tag.fill")
                                    .font(.largeTitle)
                            } description: {
                                Text("No tags linked to this artwork")
                            }
                        }
                    case "Delivery":
                        if let deliveryDetails = artwork.deliveryDetails {
                            DeliveryDetails(deliveryDetails: deliveryDetails)
                        } else {
                            ContentUnavailableView {
                                Image(systemName: "shippingbox.and.arrow.backward.fill")
                                    .font(.largeTitle)
                            } description: {
                                Text("No delivery details found")
                            }
                        }
                    default:
                        Text("Invalid tab title")
                    }
                })

                VStack(alignment: .leading) {
                    Text("More from \(artwork.artist.name)")
                        .fontWeight(.semibold)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(artwork.artist.artworks ?? [], id: \.self) { otherArtwork in
                                // TODO: artists.artworks is currently always empty
                                if artwork.id != otherArtwork.id {
                                    ArtworkRowItem(artwork: otherArtwork, smallVersion: true)
                                }
                            }
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
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
            ToolbarItemGroup(placement: .bottomBar) {
                HStack {
                    Button {
                        showingAR = true
                    } label: {
                        Text("View in AR")
                        Image(systemName: "arkit")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    Button {
                        print("Clicked: add to cart")
                    } label: {
                        Text("Add to cart")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .fullScreenCover(isPresented: $showingAR) {
            ArArtworkView(isPresented: $showingAR)
        }
    }
}

#Preview {
//    NavigationView {
//        ArtworkPage(artwork: Artwork.mockedPreview)
//    }
    HomePage<PreviewArtworksStore>()
        .environmentObject(PreviewArtworksStore())
}
