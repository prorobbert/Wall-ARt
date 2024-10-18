//
//  ArtistsStore.swift
//  Domain
//
//  Created by Robbert Ruiter on 01/08/2024.
//

import Foundation
import Combine

public protocol ArtistsStore: AnyObject, ObservableObject {
    associatedtype EntryType: Artist
    var artists: [EntryType] { get }
    func addArtist(for user: User)
    func deleteArtist(_ artist: EntryType)
    func fetchArtists() throws
    func getRandomArtist() throws -> EntryType
    func reloadSampleData(users: [User]) throws
}
