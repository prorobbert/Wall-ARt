//
//  ContentView.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 11/06/2024.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("hello_world")
            Button(action: {  }, label: {
                Text("show_ar")
                    .font(.title2)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
