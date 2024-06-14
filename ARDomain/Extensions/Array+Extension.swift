//
//  Array+Extension.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 12/06/2024.
//

import Foundation
import ARKit

extension Array where Element == PlaneAnchor {
    /// Filters this array of horizontal plane anchors for those planes that are within a given maximum distance in meters from a given point.
    func within(meters maxDistance: Float, of originFromGivenPointTransform: matrix_float4x4) -> [PlaneAnchor] {
        var matchingPlanes: [PlaneAnchor] = []
        let originFromGivenPointY = originFromGivenPointTransform.translation.y
        for anchor in self {
            let originFromPlaneY = anchor.originFromAnchorTransform.translation.y
            let distance = abs(originFromGivenPointY - originFromPlaneY)
            if distance <= maxDistance {
                matchingPlanes.append(anchor)
            }
        }
        return matchingPlanes
    }
    
    /// Finds the plane that's closest to the given point on the y-axis from an array of horizontal plane anchors.
    func closestPlane(to originFromGivenPointTransform: matrix_float4x4) -> PlaneAnchor? {
        var shortestDistance = Float.greatestFiniteMagnitude
        var closestPlane: PlaneAnchor?
        let originFromGivenPointY = originFromGivenPointTransform.translation.y
        for anchor in self {
            let originFromPlaneY = anchor.originFromAnchorTransform.translation.y
            let distance = abs(originFromGivenPointY - originFromPlaneY)
            if distance < shortestDistance {
                shortestDistance = distance
                closestPlane = anchor
            }
        }
        return closestPlane
    }
    
    /// Filters an array of horizontal plane anchors for those planes where a given point, projected onto the plane, is inside the plane's geometry.
    func containing(pointToProject originFromGivenPointTransform: matrix_float4x4) -> [PlaneAnchor] {
        var matchingPlanes: [PlaneAnchor] = []
        for anchor in self {
            // 1. Project the given point into the plane's 2D coordinate system.
            let planeAnchorFromOriginTransform = simd_inverse(anchor.originFromAnchorTransform)
            let planeAnchorFromPointTransform = planeAnchorFromOriginTransform * originFromGivenPointTransform
            let planeAnchorFromPoint2D: SIMD2<Float> = [planeAnchorFromPointTransform.translation.x, planeAnchorFromPointTransform.translation.z]
            
            var insidePlaneGeometry = false
            
            // 2. For each triangle of the plane geometry, check whether the given point lies inside of the triangle.
            let faceCount = anchor.geometry.meshFaces.count
            for faceIndex in 0 ..< faceCount {
                let vertexIndicesForThisFace = anchor.geometry.meshFaces[faceIndex]
                let vertex1 = anchor.geometry.meshVertices[vertexIndicesForThisFace[0]]
                let vertex2 = anchor.geometry.meshVertices[vertexIndicesForThisFace[1]]
                let vertex3 = anchor.geometry.meshVertices[vertexIndicesForThisFace[2]]
                
                insidePlaneGeometry = planeAnchorFromPoint2D.isInsideOf([vertex1.0, vertex1.2], [vertex2.0, vertex2.2], [vertex3.0, vertex3.2])
                if insidePlaneGeometry {
                    matchingPlanes.append(anchor)
                    break
                }
            }
        }
        return matchingPlanes
    }
}
