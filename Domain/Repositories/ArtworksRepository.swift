//
//  ArtworksRepository.swift
//  Domain
//
//  Created by Robbert Ruiter on 26/07/2024.
//
import Foundation

public protocol ArtworksRepository: AnyObject, Observable {
    associatedtype EntryType: ArtworkEntry
    var artworks: [EntryType] { get }
    func addArtwork()
    func deleteArtwork(_ artwork: EntryType)
    func fetchArtworks() throws
}
