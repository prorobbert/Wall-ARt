//
//  Entity+Extension.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 13/06/2024.
//

import RealityKit

extension Entity {
    func applyMaterial(_ material: Material) {
        if let modelEntity = self as? ModelEntity {
            modelEntity.model?.materials = [material]
        }
        for child in children {
            child.applyMaterial(material)
        }
    }
    
    var extents: SIMD3<Float> { visualBounds(relativeTo: self).extents }
    
    func look(at target: SIMD3<Float>) {
        look(at: target,
            from: position(relativeTo: nil),
            relativeTo: nil,
             forward: .positiveZ)
    }
}
