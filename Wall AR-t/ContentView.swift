//
//  ContentView.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 11/06/2024.
//

import Domain
import SwiftData
import SwiftUI

struct ContentView<Store: ArtworksStore, Store2: ArtistsStore, Store3: UsersStore>: View {
    @EnvironmentObject var artworksStore: Store
    @EnvironmentObject var artistsStore: Store2
    @EnvironmentObject var usersStore: Store3
    @State private var showingAR = false
    @State private var artist: Artist?
    @State private var artworkSortOrder = ArtworkSortOrder.title
    @State private var filter = ""

    var body: some View {
        NavigationStack {
            Picker("", selection: $artworkSortOrder) {
                ForEach(ArtworkSortOrder.allCases) { sortOrder in
                    Text("Sort by \(sortOrder.rawValue)").tag(sortOrder)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: artworkSortOrder) {
                artworksStore.setSortOrder(artworkSortOrder)
            }
            List(artworksStore.artworks) { artwork in
                VStack {
                    Text(artwork.title)
                    Text(artwork.dimensions(.centimeters))
                    Text(Medium(rawValue: artwork.medium)!.label)
                }
                    .swipeActions {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            artworksStore.deleteArtwork(artwork)
                        }
                    }
            }
            .searchable(text: $filter, prompt: Text("Filter on title"))
            .onChange(of: filter) {
                artworksStore.setFilter(filter)
            }
            .toolbar {
                Button("Add") {
                    artworksStore.addArtwork(for: artist!)
                }
            }
            .onAppear {
                do {
                    // Make sure that there is an artist because of debug reasons
                    if artist == nil {
                        let user = usersStore.getSingleUser()
                        if artistsStore.artists.isEmpty {
                            artistsStore.addArtist(for: user)
                        }
                        try artistsStore.fetchArtists()
                        self.artist = try? artistsStore.getRandomArtist()
                    }
                } catch {}
            }

            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("hello_world")
                Button(action: { showingAR = true }, label: {
                    Text("show_ar")
                        .font(.title2)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                })
            }
            .padding()
            .fullScreenCover(isPresented: $showingAR) {
                ArArtworkView(isPresented: $showingAR)
            }
        }
    }
}

#Preview {
    return ContentView<PreviewArtworksStore, PreviewArtistsStore, PreviewUsersStore>()
        .environmentObject(PreviewArtworksStore())
        .environmentObject(PreviewArtistsStore())
        .environmentObject(PreviewUsersStore())
}
