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
                        .fill(Color.clear)
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Image(artwork.photoFileName)
                                .resizable()
                                .scaledToFit()
                        }
                    VStack(alignment: .leading) {
                        Text(artwork.title)
                            .appFont(.title1)
                        HStack {
                            Text("by")
                                .appFont(.subHeadline)
                                .foregroundStyle(Color.gray.opacity(0.5))
                            Text(artwork.artist.name)
                                .appFont(.subHeadline)
                            Spacer()
                            Text(formatPrice(artwork.price))
                                .appFont(.headline)
                        }
                    }
                }
                .frame(maxWidth: .infinity)

                VStack(alignment: .leading) {
                    Text("Description")
                        .appFont(.bodyEmpasized)
                    Text(artwork.story)
                        .appFont(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                TabSelectionView(tabTitles: ["Details", "Tags", "Delivery"], content: { title in
                    switch title {
                    case "Details":
                        VStack(alignment: .leading) {
                            HStack {
                                Text("•")
                                    .appFont(.body)
                                Text(ArtworkEdition(rawValue: artwork.edition)!.label)
                                    .appFont(.body)
                            }
                            HStack {
                                Text("•")
                                    .appFont(.body)
                                Text(Medium(rawValue: artwork.medium)!.label)
                                    .appFont(.body)
                            }
                            HStack {
                                Text("•")
                                    .appFont(.body)
                                Text("Size: \(artwork.dimensions(.centimeters))")
                                    .appFont(.body)
                            }
                            HStack {
                                Text("•")
                                    .appFont(.body)
                                Text("Style: \(artwork.style)")
                                    .appFont(.body)
                            }
                            HStack {
                                Text("•")
                                    .appFont(.body)
                                Text("Subject: \(artwork.subject)")
                                    .appFont(.body)
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
                        .appFont(.bodyEmpasized)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(artwork.artist.artworks, id: \.self) { otherArtwork in
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
                            .appFont(.headline)
                        Image(systemName: "arkit")
                            .appFont(.headline)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    Button {
                        print("Clicked: add to cart")
                    } label: {
                        Text("Add to cart")
                            .appFont(.headline)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .fullScreenCover(isPresented: $showingAR) {
            ArArtworkView(artwork: artwork, isPresented: $showingAR)
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
