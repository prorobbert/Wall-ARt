//
//  FlexibleGrid.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 14/08/2024.
//

import SwiftUI
import Domain

struct FlexibleGrid<Element: Identifiable, Content: View>: View {

    let elements: [Element]
    let builder: (Element) -> Content
    let spacing: CGFloat

    @State
    var widths: [Element.ID: CGFloat] = [:]

    @State
    var size: CGSize = .zero

    init(_ elements: [Element], spacing: CGFloat = 10, builder: @escaping (Element) -> Content) {
        self.elements = elements
        self.spacing = spacing
        self.builder = builder
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: spacing) {
                ForEach(makeRows(in: geometry)) { elements in
                    HStack(alignment: .top, spacing: spacing) {
                        ForEach(elements) { element in
                            builder(element)
                                .onSizeChange { size in
                                    guard widths[element.id] != size.width else { return }
                                    widths[element.id] = size.width
                                }
                        }
                    }
                    .padding(.trailing, -1000) // To make sure texts don't wrap around
                }
            }
            .withSizeBinding($size)
        }
        .frame(height: size.height)
    }
}

private extension FlexibleGrid {

    func makeRows(in geometry: GeometryProxy) -> [[Element]] {
        var rows: [[Element]] = []
        var toAdd: [Element] = elements
        var row: [Element] = []
        var rowWidth: CGFloat = 0
        while !toAdd.isEmpty, rowWidth < geometry.size.width {
            let item = toAdd.popFirst()!
            let itemWidth = widths[item.id] ?? 0
            let widthToAdd = itemWidth + spacing
            if (rowWidth + widthToAdd) < geometry.size.width {
                row.append(item)
                rowWidth += widthToAdd
            } else {
                rows.append(row)
                row = [item]
                rowWidth = itemWidth
            }
        }
        if !row.isEmpty {
            rows.append(row)
        }
        return rows
    }
}

#Preview {
    let tags: [Tag] = .mockedPreview
    return FlexibleGrid(tags, spacing: 8) { tag in
        Text(tag.title)
    }
    .padding(20)
}
