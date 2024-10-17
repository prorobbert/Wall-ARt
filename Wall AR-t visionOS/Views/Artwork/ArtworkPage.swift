//
//  ArtworkPage.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 17/10/2024.
//

import Domain
import SwiftUI

struct ArtworkPage: View {
    var artwork: Artwork

    @State private var showingAR = false

    var body: some View {
        Text("Showing detail of \(artwork.title)")
    }
}

#Preview {
    HomePage<PreviewArtworksStore>()
        .environmentObject(PreviewArtworksStore())
}
