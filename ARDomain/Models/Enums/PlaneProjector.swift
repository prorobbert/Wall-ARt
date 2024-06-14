//
//  PlaneProjector.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 13/06/2024.
//

import Foundation
import ARKit
import RealityKit

enum PlaneProjector {
    /// Projects a given point onto a nearby horizontal plane from a given set of planes.
    static func project(point originFromPointTransform: matrix_float4x4, ontoHorizontalPlaneIn planeAnchors: [PlaneAnchor], withMaxDistance: Float) -> matrix_float4x4? {
        // 1. Only consider planes that are horizontal.
        let horizontalPlanes = planeAnchors.filter({ $0.alignment == .horizontal })
        
        // 2. Only consider planes that are within the given maximum distance.
        let inVerticalRangePlanes = horizontalPlanes.within(meters: withMaxDistance, of: originFromPointTransform)
        
        // 3. Only consider planes where the given point, projected onto the plane, is inside the plane's geometry.
        let matchingPlanes = inVerticalRangePlanes.containing(pointToProject: originFromPointTransform)
        
        //4. Of all matching planes, pick the closest one.
        if let closestPlane = matchingPlanes.closestPlane(to: originFromPointTransform) {
            // Return the given point's transform with the position on y-axis changed to the Y value of the closest horizontal plane.
            var result = originFromPointTransform
            result.translation = [originFromPointTransform.translation.x, closestPlane.originFromAnchorTransform.translation.y, originFromPointTransform.translation.z]
            return result
        }
        return nil
    }
    
    // TODO: update for vertical planes
}
