//
//  ProfilePage.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 13/09/2024.
//

import Domain
import SwiftUI

struct ProfilePage: View {
    @StateObject var navigationStore = NavigationStore()

    @EnvironmentObject var artworksStore: RealArtworksStore
    @EnvironmentObject var usersStore: RealUsersStore
    @EnvironmentObject var artistsStore: RealArtistsStore

    @State private var isReloadModalPresented = false

    var body: some View {
        NavigationStack(path: $navigationStore.path) {
            Text("Profile page")
            Button {
                isReloadModalPresented = true
            } label: {
                Text("Reload sample data")
            }
        }
        .alert("Reload sample data?", isPresented: $isReloadModalPresented) {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                Button("Yes, but nothing will happen", role: .destructive) {}
            } else {
                Button("Yes, reload sample data", role: .destructive) {
                    reloadData()
                }
            }
        }
    }

    @MainActor
    private func reloadData() {
        do {
            try reloadSampleData(userStore: usersStore, artistStore: artistsStore, artworksStore: artworksStore)
            print("Finihed reloading sample data")
        } catch {
            print("Failed to reload sample data: \(error)")
        }
    }
}

#Preview {
    ProfilePage()
}
