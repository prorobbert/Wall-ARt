//
//  ArtworkDetailItem.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 30/10/2024.
//

import SwiftUI

struct ArtworkDetailItem: View {
    var title: String
    var value: Text
    var body: some View {
        HStack(alignment: .top) {
            Text("\(title):")
                .fontWeight(.semibold)
                .frame(width: 100, alignment: .leading)
            value
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    ArtworkDetailItem(title: "Subject", value: Text("The Great Wall of China"))
}
