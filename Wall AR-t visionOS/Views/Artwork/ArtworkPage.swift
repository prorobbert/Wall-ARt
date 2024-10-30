//
//  ArtworkPage.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 17/10/2024.
//

import Domain
import RealityKit
import SwiftUI

struct ArtworkPage: View {
    var artwork: Artwork

    @State private var showingAR = false

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 12) {
                // Left column
                VStack {
                    ArtworkPreviewView(photoFileName: artwork.photoFileName)
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.8)
                        .clipped()
                    Button(action: {
                        placeArtworkInRoom()
                    }) {
                        Text("Place in my room")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                    }
                    .padding(.top, 20)
                }
                .frame(width: geometry.size.width * 0.5, height: geometry.size.height)
                // Right column
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(artwork.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 4)
                        Text("by \(artwork.artist.name)")
                            .font(.title2)
                        Text(formatPrice(artwork.price))
                            .font(.title3)
                        ArtworkDetailItem(
                            title: "Medium",
                            value: Text(Medium(rawValue: artwork.medium)!.label)
                        )
                        ArtworkDetailItem(
                            title: "Dimensions",
                            value: Text(artwork.dimensions(.centimeters))
                        )
                        ArtworkDetailItem(
                            title: "Subject",
                            value: Text(artwork.subject)
                        )
                        ArtworkDetailItem(
                            title: "Style",
                            value: Text(artwork.style)
                        )
                        ArtworkDetailItem(
                            title: "Edition",
                            value: Text(ArtworkEdition(rawValue: artwork.edition)!.label)
                        )
                        ArtworkDetailItem(
                            title: "Availability",
                            value: Text(artwork.isAvailable ? "Available" : "Sold")
                        )
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Story")
                                .font(.headline)
                            Text(artwork.story)
                                .font(.body)
                        }

                        if let tags = artwork.tags, !tags.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Tags")
                                ArtworkTags(items: tags.map { $0.title })
                            }
                        }

                        if let delivery = artwork.deliveryDetails {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Delivery details")
                                    .font(.headline)
                                Text(delivery.shippingFrom)
                                    .font(.body)
                            }
                        }

                        Spacer()
                    }
                    .padding()
                }
                .frame(width: geometry.size.width * 0.5)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .padding(.horizontal, 20)
        }

    }
    private func placeArtworkInRoom() {
        print("Placing \(artwork.title) in the users room")
        // TODO: add placing logic
    }
}

#Preview {
    HomePage<PreviewArtworksStore>()
        .environmentObject(PreviewArtworksStore())
}
