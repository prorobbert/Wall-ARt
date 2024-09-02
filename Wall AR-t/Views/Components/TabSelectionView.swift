//
//  TabSelectionView.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 12/08/2024.
//

import SwiftUI

extension String: Identifiable {
    public var id: String { self }
}

struct TabSelectionView<Content: View>: View {

    let tabTitles: [String]
    let content: (String) -> Content

    @State var selectedTitle: String

    init(tabTitles: [String], @ViewBuilder content: @escaping (String) -> Content) {
        self.tabTitles = tabTitles
        self.content = content
        selectedTitle = tabTitles.first!
    }

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(tabTitles) { title in
                    VStack {
                        Button(action: {
                            withAnimation {
                                selectedTitle = title
                            }
                        }, label: {
                            Text(title)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.black).opacity(isSelected(title: title) ? 1 : 0.65)
                        })
                        ZStack {
                            Color.gray.opacity(0.5)
                                .padding(.horizontal, 2)
                                .frame(height: 2)
                            Color.wallARtPrimary
                                .padding(.horizontal, 2)
                                .frame(height: 2)
                            .opacity(isSelected(title: title) ? 1 : 0)
                        }
                    }
                }
            }
            content(selectedTitle)
                .padding(.top, 10)
        }
    }
}

extension TabSelectionView {
    func isSelected(title: String) -> Bool {
        return title == selectedTitle
    }
}

#Preview {
    TabSelectionView(tabTitles: ["Details", "Tags", "Delivery"], content: { title in
        switch title {
        case "Details":
            Text("Details tab")
        case "Tags":
            Text("Tags tab")
        case "Delivery":
            Text("Delivery tab")
        default:
            Text("Invalid tab title")
        }
    })
}
