//
//  ProfilePage.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 07/08/2024.
//

import Domain
import SwiftUI

struct ProfilePage: View {
    @StateObject var navigationStore = NavigationStore()

    @EnvironmentObject var artworksStore: RealArtworksStore
    @EnvironmentObject var usersStore: RealUsersStore
    @EnvironmentObject var artistsStore: RealArtistsStore

    @State private var isReloadPresented = false

    var body: some View {
        NavigationStack(path: $navigationStore.path) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(Color.gray.opacity(0.2))
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Full name")
                            Text("@username")
                            Text("297 Followers   31 Following")
                        }
                    }
                    Button {
                        isReloadPresented = true
                    } label: {
                        Text("Reload sample data")
                    }
                }
                .padding(.horizontal, 20)
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
            .navigationTitle("My profile")
            .toolbar {
                Button {} label: {
                    Label("", systemImage: "gear")
                        .help("Settings")
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
    ProfilePage()
}
