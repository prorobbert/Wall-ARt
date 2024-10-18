//
//  CartPage.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 13/09/2024.
//

import SwiftUI

struct CartPage: View {
    @StateObject var navigationStore = NavigationStore()

    var body: some View {
        NavigationStack(path: $navigationStore.path) {
            Text("Cart page")
        }
    }
}

#Preview {
    CartPage()
}
