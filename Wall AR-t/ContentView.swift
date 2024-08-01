//
//  ContentView.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 11/06/2024.
//

import Domain
import SwiftData
import SwiftUI

struct ContentView<Store: ArtworksStore>: View {
    @EnvironmentObject var artworkStore: Store
    @EnvironmentObject var artistStore: RealArtistsStore
    @State private var showingAR = false
    @State private var artist: Artist?

//    init() {
//        do {
//            self.artist = try artistStore.getRandomArtist()
//        } catch {}
//    }

    var body: some View {
        NavigationStack {
            List(artworkStore.artworks) { artwork in
                Text("\(artwork.title) - \(artwork.dimensions(.centimeters))")
                    .swipeActions {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            artworkStore.deleteArtwork(artwork)
                        }
                    }
            }
            .toolbar {
                Button("Add") {
                    artworkStore.addArtwork(for: artist!)
                }
            }
            .onAppear {
                do {
                    try artworkStore.fetchArtworks()
                    try artistStore.fetchArtists()
                    if artist == nil {
                        self.artist = try? artistStore.getRandomArtist()
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
    return ContentView<PreviewArtworksStore>()
        .environmentObject(PreviewArtworksStore())
}
