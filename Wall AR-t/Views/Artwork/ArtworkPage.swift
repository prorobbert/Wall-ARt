//
//  ArtworkPage.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 07/08/2024.
//

import SwiftUI
import Domain

struct ArtworkPage: View {
    var artwork: Artwork

    var body: some View {
        ScrollView {
            Rectangle()
                .frame(width: 400, height: 400)
        }
        .trackScreen(Analytics(screen: .artwork, parameters: ["artwork": artwork.title]))
        Text(artwork.title)
    }
}

#Preview {
    ArtworkPage(artwork: Artwork.mockedPreview)
}
