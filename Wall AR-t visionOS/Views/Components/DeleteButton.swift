//
//  DeleteButton.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 13/06/2024.
//

import SwiftUI

struct DeleteButton: View {
    var deletionHandler: (() -> Void)?

    var body: some View {
        Button {
            if let deletionHandler {
                deletionHandler()
            }
        } label: {
            Image(systemName: "trash")
        }
        .accessibilityLabel("delete_object")
        .glassBackgroundEffect()
    }
}

#Preview(windowStyle: .plain) {
    DeleteButton()
}
