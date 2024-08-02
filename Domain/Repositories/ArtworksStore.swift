//
//  ArtworksRepository.swift
//  Domain
//
//  Created by Robbert Ruiter on 26/07/2024.
//
import Foundation
import Combine

public protocol ArtworksStore: AnyObject, Observable, ObservableObject {
    associatedtype EntryType: Artwork
    var artworks: [EntryType] { get }
    func setSortOrder(_ sortOrder: ArtworkSortOrder)
    func setFilter(_ filterString: String)
    func addArtwork(for artist: Artist)
    func deleteArtwork(_ artwork: EntryType)
    func fetchArtworks() throws
}
