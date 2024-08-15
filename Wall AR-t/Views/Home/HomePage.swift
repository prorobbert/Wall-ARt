//
//  HomePage.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 05/08/2024.
//

import Domain
import SwiftUI

struct HomePage<Store: ArtworksStore>: View {
    @StateObject var navigationStore = NavigationStore()

    @EnvironmentObject var artworksStore: Store
    @EnvironmentObject var usersStore: RealUsersStore
    @EnvironmentObject var artistsStore: RealArtistsStore

    @State private var isReloadPresented = false

    var body: some View {
        NavigationStack(path: $navigationStore.path) {
            HStack(spacing: 8) {
                Color.gray.opacity(0.2)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                .frame(width: 32, height: 32)
                Text("Wall AR-t")
                Spacer()
            }
            .padding(.horizontal, 20)
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    ArtworkRow(title: "Popular artworks", artworks: artworksStore.artworks)
                    CategoryList()
                    ArtworkRow(title: "New artworks", artworks: artworksStore.artworks)
                }
                .padding(.horizontal, 20)
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.Keys.homePage)
            .withPageDestination()
            .trackScreen(Analytics(screen: .home))
            .environmentObject(navigationStore)
            .toolbar {
                Button {
                    isReloadPresented = true
                } label: {
                    Label("", systemImage: "arrow.clockwise")
                        .help("Reload sample data")
                }
            }
            .alert("Reload sample data?", isPresented: $isReloadPresented) {
                if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                    Button("Yes, but nothing will happen", role: .destructive) {}
                } else {
                    Button("Yes, reload sample data", role: .destructive) {
                        reloadSampleData()
                    }
                }
            }
        }
    }

    @MainActor
    private func reloadSampleData() {
        usersStore.reloadSampleData()
        let users = usersStore.users
        artistsStore.reloadSampleData(users: users)
        let artists = artistsStore.artists
        let tags: [Tag] = .mockedPreview
        artworksStore.reloadSampleData(artists: artists, tags: tags)
        print("Finished reloading")
    }
}

#Preview {
    HomePage<PreviewArtworksStore>()
        .environmentObject(PreviewArtworksStore())
}
