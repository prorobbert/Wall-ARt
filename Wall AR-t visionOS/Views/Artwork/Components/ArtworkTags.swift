//
//  WrapHStack.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 30/10/2024.
//

import SwiftUI

struct ArtworkTags: View {
    let items: [String]
    let spacing: CGFloat = 8
    let alignment: HorizontalAlignment = .leading

    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 80), spacing: spacing)
        ]

        LazyVGrid(columns: columns, alignment: alignment, spacing: spacing) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                    .font(.caption)
            }
        }
    }
}
