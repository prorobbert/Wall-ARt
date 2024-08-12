//
//  CategoryList.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 12/08/2024.
//

import SwiftUI

struct CategoryList: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(["Landscapes", "Animals", "Portraits", "Florals", "Still life"], id: \.self) { category in
                    Text(category)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                        )
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                Text("View all categories")
                    .font(.caption)
                    .foregroundStyle(Color.gray.opacity(0.8))
            }
        }
    }
}

#Preview {
    CategoryList()
}
