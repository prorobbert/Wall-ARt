//
//  ContentView.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 11/06/2024.
//

import SwiftUI
import Domain
import ARDomain

struct ContentView: View {
    let artItem = Artwork(title: "Hello mom")
    let artEntity = ArtworkEntity(artwork: Artwork(title: "Hi dad"))
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
