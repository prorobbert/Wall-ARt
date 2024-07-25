//
//  FocusSquare+Alignment+Extension.swift
//  ARDomainiOS
//
//  Created by Robbert Ruiter on 04/07/2024.
//

import RealityKit
import Combine
#if canImport(ARKit)
import ARKit
#endif

extension FocusSquare {
    // MARK: Helper methods

    /// Update the position of the focus square.
    internal func updatePosition() {
        // Average using several most recent positions.
        recentFocusSquarePositions = Array(recentFocusSquarePositions.suffix(10))

        // Move the average of recent positions to avoid jitter.
        let average = recentFocusSquarePositions.reduce(
            SIMD3<Float>.zero, { $0 + $1 }
        ) / Float(recentFocusSquarePositions.count)
        self.position = average
    }

    internal func normalize(_ angle: Float, forMinimalRotationTo ref: Float) -> Float {
        // Normalize the angle in steps of 90 degrees such that the rotation to the other angle is minimal
        var normalized = angle
        while abs(normalized - ref) > .pi / 4 {
            if angle > ref {
                normalized -= .pi / 2
            } else {
                normalized += .pi / 2
            }
        }
        return normalized
    }

    internal func getCameraVector() -> (position: SIMD3<Float>, direction: SIMD3<Float>)? {
        guard let camTransform = self.arView?.cameraTransform else { return nil }

        let camDirection = camTransform.matrix.columns.2
        return (camTransform.translation, -[camDirection.x, camDirection.y, camDirection.z])
    }

    #if canImport(ARKit)
    /// Update the transformof the focus square to be aligned with the camera.
    internal func updateTransform(raycastResult: ARRaycastResult) {
        self.updatePosition()

        if state != .initializing {
            updateAlignment(for: raycastResult)
        }
    }

    internal func updateAlignment(for raycastResult: ARRaycastResult) {
        var targetAlignment = raycastResult.worldTransform.orientation

        // Determine current alignment.
        var alignment: ARPlaneAnchor.Alignment?
        if let planeAnchor = raycastResult.anchor as? ARPlaneAnchor {
            alignment = planeAnchor.alignment
            // Catching case when looking at the ceiling
            if targetAlignment.act([0, 1, 0]).y < -0.9 {
                targetAlignment *= simd_quatf(angle: .pi, axis: [0, 1, 0])
            }
        } else if raycastResult.targetAlignment == .horizontal {
            alignment = .horizontal
        } else if raycastResult.targetAlignment == .vertical {
            alignment = .vertical
        }

        // Add to list of recent alignments.
        if alignment != nil {
            self.recentFocusSquareAlignments.append(alignment!)
        }

        // Average using several most recent alignments.
        self.recentFocusSquareAlignments = Array(self.recentFocusSquareAlignments.suffix(20))

        let alignmentCount = self.recentFocusSquareAlignments.count
        let horizontalHistory = recentFocusSquareAlignments.filter({ $0 == .horizontal }).count
        let verticalHistory = recentFocusSquareAlignments.filter({ $0 == .vertical }).count

        // If the alignment is the same as most of the history, change it
        if alignment == .horizontal && horizontalHistory > alignmentCount * 3/4 ||
            alignment == .vertical && verticalHistory > alignmentCount / 2 ||
            raycastResult.anchor is ARPlaneAnchor {
            if alignment != self.currentAlignment ||
                (alignment == .vertical && self.shouldContinueAlignmentAnimation(to: targetAlignment)
                ) {
                isChangingAlignment = true
                self.currentAlignment = alignment
            }
        } else {
            return
        }

        // Change the focus entity's alignment
        if isChangingAlignment {
            performAlignmentAnimation(to: targetAlignment)
        } else {
            orientation = targetAlignment
        }
    }

    /// - Parameters:
    /// - Returns: ARRaycastResult if an existing plane geometry or an estimated plane are found, otherwise nil.
    internal func smartRaycast() -> ARRaycastResult? {
        guard let (cameraPosition, cameraDirection) = self.getCameraVector() else { return nil }

        for target in self.allowedRaycasts {
            let raycastQuery = ARRaycastQuery(origin: cameraPosition, direction: cameraDirection, allowing: target, alignment: .any)
            let results = self.arView?.session.raycast(raycastQuery) ?? []

            if let result = results.first(
                where: { $0.target == target }
            ) { return result }
        }
        return nil
    }

    /**
     Reduce visual size change with distance by scaling up when close and down when far away.
     
     These adjustments result in a scale of 1.0x for a distance of 0.7 m or less
     (estimated distance when looking at a table), and a scale of 1.2x
     for a distance 1.5 m distance (estimated distance when looking at the floor).
     */
    internal func scaleBasedOnDistance(camera: ARCamera?) -> Float {
        guard let camera = camera else { return 1.0 }

        let distanceFromCamera = simd_length(self.convert(position: .zero, to: nil) - camera.transform.translation)
        if distanceFromCamera < 0.7 {
            return distanceFromCamera / 0.7
        } else {
            return 0.25 * distanceFromCamera + 0.825
        }
    }
    #endif
    
    internal func performAlignmentAnimation(to newOrientation: simd_quatf) {
        // Interpolate between current and target orientation.
        orientation = simd_slerp(orientation, newOrientation, 0.15)
        // This length creates a normalized vector (of length 1) with all 3 components being equal.
        self.isChangingAlignment = self.shouldContinueAlignmentAnimation(to: newOrientation)
    }
    
    func shouldContinueAlignmentAnimation(to newOrientation: simd_quatf) -> Bool {
        let testVector = simd_float3(repeating: 1 / sqrtf(3))
        let point1 = orientation.act(testVector)
        let point2 = newOrientation.act(testVector)
        let vectorDot = simd_dot(point1, point2)
        // Stop interpolating when the rotations are close enough to each other.
        return vectorDot < 0.999
    }
}
