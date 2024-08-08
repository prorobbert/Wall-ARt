//
//  TabBar.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 05/08/2024.
//

import Domain
import SwiftUI

struct TabBar: View {

    @State private var activeTab: Tab = .home

    var body: some View {
        TabView(selection: $activeTab) {
            HomePage<RealArtworksStore>()
                .tabItem {
                    TabItem(identifier: .home, activeTab: activeTab)
                }
                .tag(Tab.home)
            DiscoverPage()
                .tabItem {
                    TabItem(identifier: .discover, activeTab: activeTab)
                }
                .tag(Tab.discover)
            CartPage()
                .tabItem {
                    TabItem(identifier: .cart, activeTab: activeTab)
                }
                .tag(Tab.cart)
            ProfilePage()
                .tabItem {
                    TabItem(identifier: .profile, activeTab: activeTab)
                }
                .tag(Tab.profile)
        }
        .tint(.wallARtPrimary)
    }
}

#Preview {
    TabBar()
}
