//
//  ArArtworkView.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 27/06/2024.
//

import Domain
import SwiftUI

struct ArArtworkView: View {
    var artwork: Artwork
    @Binding var isPresented: Bool
    @State private var isCoachingComplete = false

    var body: some View {
        ZStack {
            RealityKitView(artwork: artwork, isCoachingComplete: $isCoachingComplete)
                .ignoresSafeArea()

            VStack {
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Image(systemName: "xmark.circle")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                })
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .trailing)

                Spacer()
                if isCoachingComplete {
                    Text("tap_to_place_objects")
                        .font(.headline)
                        .padding()
                        .background(Color.white.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                        .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
