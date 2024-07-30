//
//  ContentView.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 11/06/2024.
//

import Domain
import SwiftData
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var artworkStore: ArtworksStore
    @State private var showingAR = false

    var body: some View {
        NavigationStack {
            List(artworkStore.artworks) { artwork in
                Text(artwork.title)
                    .swipeActions {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            artworkStore.deleteArtwork(artwork)
                        }
                    }
            }
            .toolbar {
                Button("Add") {
                    artworkStore.addArtwork()
                }
            }
            .onAppear {
                do {
                    try artworkStore.fetchArtworks()
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

//#Preview {
//    ContentView()
//        .environmentObject(PreviewArtworkStore(artworks: [
//            Artwork(title: "Hi"),
//            Artwork(title: "Hello"),
//            Artwork(title: "Greetings"),
//        ])
//        )
//}
