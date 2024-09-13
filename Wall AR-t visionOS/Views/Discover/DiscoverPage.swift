//
//  DiscoverPage.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 13/09/2024.
//

import SwiftUI

struct DiscoverPage: View {
    @StateObject var navigationStore = NavigationStore()

    var body: some View {
        NavigationStack(path: $navigationStore.path) {
            Text("So much to discover")
        }
    }
}

#Preview {
    DiscoverPage()
}
