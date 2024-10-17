//
//  ReloadSampleData.swift
//  Domain
//
//  Created by Robbert Ruiter on 17/10/2024.
//

@MainActor
public func reloadSampleData(
    userStore: RealUsersStore,
    artistStore: RealArtistsStore,
    artworksStore: RealArtworksStore
) throws {
    try userStore.reloadSampleData()
    let users = userStore.users
    try artistStore.reloadSampleData(users: users)
    let artists = artistStore.artists
    let tags: [Tag] = .mockedPreview
    try artworksStore.reloadSampleData(artists: artists, tags: tags)
}
