//
//  ProfilePage.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 07/08/2024.
//

import SwiftUI

struct ProfilePage: View {
    @StateObject var navigationStore = NavigationStore()

    var body: some View {
        NavigationStack(path: $navigationStore.path) {
            Text("Profile page")
        }
    }
}

#Preview {
    ProfilePage()
}
