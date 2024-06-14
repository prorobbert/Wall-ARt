//
//  TooltipView.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 13/06/2024.
//

import SwiftUI

struct TooltipView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 220)
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
            .glassBackgroundEffect()
            .allowsHitTesting(false) // Prevent the tooltip from blocking spatial tap gestures.
    }
}

#Preview(windowStyle: .plain) {
    TooltipView(text: "A piece of sample text.")
}
