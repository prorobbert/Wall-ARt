//
//  ArtworkDatabase.swift
//  Domain
//
//  Created by Robbert Ruiter on 26/07/2024.
//

import SwiftData
import Foundation

public struct ArtworkDatabase {
    public let modelContainer: ModelContainer

    @MainActor
    public init(isStoredInMemoryOnly: Bool = false) {
        let modelConfiguration = ModelConfiguration(
            isStoredInMemoryOnly: isStoredInMemoryOnly
        )
        do {
            self.modelContainer = try ModelContainer(
                for: Artwork.self,
                configurations: modelConfiguration
            )
        } catch {
            print(error)
            fatalError()
        }

//        if false {
//            var user = User.mockedPreview
//            self.modelContainer.mainContext.insert(user)
//            do {
//                user = try self.modelContainer.mainContext.fetch(FetchDescriptor<User>(sortBy: [SortDescriptor(\.firstName)]))[0]
//            } catch {}
//
//            let tempArtist = Artist.mockedPreview
//            var artist = Artist(personalInfo: tempArtist.personalInfo, user: user)
//            self.modelContainer.mainContext.insert(artist)
//            do {
//                artist = try self.modelContainer.mainContext.fetch(FetchDescriptor<Artist>(sortBy: [SortDescriptor(\.user.firstName)]))[0]
//            } catch {}
//
//            var delivery = Delivery.mockedPreview
//            self.modelContainer.mainContext.insert(delivery)
//            do {
//                delivery = try self.modelContainer.mainContext.fetch(FetchDescriptor<Delivery>())[0]
//            } catch {}
//
//            var tags: [Tag] = [Tag(title: "Bird"), Tag(title: "Animal"), Tag(title: "Wildlife")]
//            for tag in tags {
//                self.modelContainer.mainContext.insert(tag)
//            }
//            do {
//                tags = try self.modelContainer.mainContext.fetch(FetchDescriptor<Tag>())
//            } catch {
//                tags = []
//            }
//            var artworks: [Artwork] = .mockedPreview
//            print("testing something. Artworks: \(artworks.count)")
//
//            for artwork in artworks {
//                if let medium = Medium(rawValue: artwork.medium) {
//                    let newArtwork = Artwork(
//                        title: artwork.title,
//                        story: artwork.story,
//                        medium: medium,
//                        price: artwork.price,
//                        width: artwork.width,
//                        height: artwork.height,
//                        depth: artwork.depth,
//                        subject: "Animals and birds",
//                        style: "Photorealistic",
//                        edition: .oneOfAkind,
//                        artist: artist,
//                        deliveryDetails: delivery,
//                        tags: tags,
//                        photoFileName: "Hand_Painting",
//                        modelFileName: "Hand_Painting"
//                    )
//                    self.modelContainer.mainContext.insert(newArtwork)
//                } else {
//
//                }
//            }
//            do {
//                artworks = try self.modelContainer.mainContext.fetch(FetchDescriptor<Artwork>(sortBy: [SortDescriptor(\.title)]))
//            } catch {
//                print("Something went wrong fetching mock artworks: \(error)")
//            }
//        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
