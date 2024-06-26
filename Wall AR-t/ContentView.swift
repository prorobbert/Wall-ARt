//
//  ContentView.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 11/06/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAR = false

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("hello_world")
            Button(action: { showingAR = true }, label: {
                Text("show_ar")
                    .font(.title2)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
            })
        }
        .padding()
        .fullScreenCover(isPresented: $showingAR) {
            ARContentView()
        }
    }
}

#Preview {
    ContentView()
}
