//
//  View+Extensions.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 05/08/2024.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func withPageDestination() -> some View {
        self.navigationDestination(for: Page.self) { destination in
            switch destination {
            case .artwork(let artwork):
                HomePage(greeting: "Artwork")
                    .toolbar(.hidden, for: .tabBar)
            case .account:
                HomePage(greeting: "Account")
                    .toolbar(.hidden, for: .tabBar)
            }
        }
    }
}
