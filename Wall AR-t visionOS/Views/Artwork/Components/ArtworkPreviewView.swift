//
//  ArtworkImageView.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 30/10/2024.
//

import SwiftUI

struct ArtworkPreviewView: View {
    let photoFileName: String

    var body: some View {
//        RealityView { content in
//            do {
//                let modelEntity = try ModelEntity.loadModel(named: artwork.modelFileName)
//                let anchor = AnchorEntity(plane: .any)
//                anchor.addChild(modelEntity)
//                content.add(anchor)
//            } catch {
//                print("Error loading model \(artwork.modelFileName): \(error.localizedDescription)")
//            }
//        }
        Image(photoFileName)
            .resizable()
            .padding(30)
            .scaledToFit()
            .background(Color.black.opacity(0.1))
            .cornerRadius(20)
            .clipped()
    }
}
