//
//  TabBar.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 05/08/2024.
//

import SwiftUI

struct TabBar: View {

    @State private var activeTab: Tab = .home

    var body: some View {
        TabView(selection: $activeTab) {
            HomePage(greeting: "Home")
                .tabItem {
                    TabItem(identifier: .home, activeTab: activeTab)
                }
                .tag(Tab.home)
            HomePage(greeting: "Discover")
                .tabItem {
                    TabItem(identifier: .discover, activeTab: activeTab)
                }
                .tag(Tab.discover)
            HomePage(greeting: "Cart")
                .tabItem {
                    TabItem(identifier: .cart, activeTab: activeTab)
                }
                .tag(Tab.cart)
            HomePage(greeting: "Profile")
                .tabItem {
                    TabItem(identifier: .profile, activeTab: activeTab)
                }
                .tag(Tab.profile)
        }
    }
}

#Preview {
    TabBar()
}
