//
//  ARContentView.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 26/06/2024.
//

import SwiftUI

struct ARContentView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ARContainerView()
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: dismiss.callAsFunction) {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 40))
                        }
                    }
                    Spacer()
                    Text("tap_a_plane_to_place_models")
                        .foregroundColor(.white)
                        .padding()
                        .background(.white.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(40)
            }
    }
}

#Preview {
    ARContentView()
}
