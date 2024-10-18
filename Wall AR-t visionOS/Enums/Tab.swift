//
//  Tab.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 13/09/2024.
//

import SwiftUI

enum Tab: Int, Hashable {

    case home, discover, cart, profile

    var image: Image {
        switch self {
        case .home:
            Image(systemName: "house")
        case .discover:
            Image(systemName: "location.circle")
        case .cart:
            Image(systemName: "cart")
        case .profile:
            Image(systemName: "person")
        }
    }
    // Possible activeImage when switching to FontAwesome icons
    var name: String {
        switch self {
        case .home:
            "Home"
        case .discover:
            "Discover"
        case .cart:
            "Cart"
        case .profile:
            "Profile"
        }
    }
}
