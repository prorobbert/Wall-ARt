//
//  HomePage.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 05/08/2024.
//

import SwiftUI

struct HomePage: View {
    @StateObject var navigationStore = NavigationStore()

    var greeting: String
    var body: some View {
        NavigationStack(path: $navigationStore.path) {
            Text(greeting)            
        }
    }
}

#Preview {
    HomePage(greeting: "Hello, World!")
}
