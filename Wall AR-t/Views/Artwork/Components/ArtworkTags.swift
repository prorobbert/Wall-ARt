//
//  ArtworkTags.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 13/08/2024.
//

import Domain
import SwiftUI

struct ArtworkTags: View {

    let tags: [Tag]

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            FlexibleGrid(tags, spacing: 8) { tag in
                Text(tag.title)
                    .lineLimit(1)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                    )
                    .foregroundColor(.black)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

#Preview {
    let mockTags: [Tag] = .mockedPreview
    return ArtworkTags(tags: mockTags)
        .padding(20)
}
