//
//  TabItem.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 13/09/2024.
//

import SwiftUI

struct TabItem: View {

    var identifier: Tab
    var activeTab: Tab

    var body: some View {
        VStack {
            if activeTab == identifier {
                identifier.image
            } else {
                identifier.image
                    .environment(\.symbolVariants, .none)
            }

            Text(identifier.name)
        }
    }
}
