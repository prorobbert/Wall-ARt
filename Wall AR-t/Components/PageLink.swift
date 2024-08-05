//
//  PageLink.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 05/08/2024.
//

import SwiftUI

struct PageLink<Content: View>: View {

    @State var isLinkActive = false

    let page: Page
    let content: () -> Content

    init(_ page: Page, @ViewBuilder content: @escaping () -> Content) {
        self.page = page
        self.content = content
    }

    var body: some View {
        NavigationLink(
            value: page,
            label: {
                content()
            }
        )
    }
}
