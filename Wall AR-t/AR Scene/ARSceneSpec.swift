//
//  ARSceneSpec.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 26/06/2024.
//

import Foundation

final class ARSceneSpec {
    struct ModelSpec {
        let fileName: String
    }
    static let models: [ModelSpec] = [
        ModelSpec(fileName: "Statues")
    ]
    static let position: SIMD3<Float> = .zero
}
