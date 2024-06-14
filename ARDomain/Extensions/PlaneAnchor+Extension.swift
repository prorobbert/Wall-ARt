//
//  PlaneAnchor+Extension.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 13/06/2024.
//

import Foundation
import ARKit
import RealityKit

extension PlaneAnchor {
    static let horizontalCollisionGroup = CollisionGroup(rawValue: 1 << 31)
    static let verticalCollisionGroup = CollisionGroup(rawValue: 1 << 30)
    static let allPlanesCollisionGroup = CollisionGroup(
        rawValue: horizontalCollisionGroup.rawValue | verticalCollisionGroup.rawValue
    )
}
