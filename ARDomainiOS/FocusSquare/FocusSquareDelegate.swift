//
//  FocusSquareDelegate.swift
//  ARDomainiOS
//
//  Created by Robbert Ruiter on 04/07/2024.
//

import Foundation
import ARKit

public protocol FocusSquareDelegate: AnyObject {
    /// Called when the FocusSquare is now in world space.
    @available(*, deprecated, message: "Use focusSquare(_:trackingUpdated:oldState:) instead.")
    func toTrackingState()

    /// Called when the FocusSquare is tracking the camera.
    @available(*, deprecated, message: "Use focusSquare(_:trackingUpdated:oldState:) instead.")
    func toInitializingState()
    
    /// When the tracking state of the FocusSquare updates, this will be called every update frame.
    /// - Parameters:
    ///   - focusSquare: FocusSquare object whose tracking state has changed.
    ///   - trackingState: New tracking state of the focus entity.
    ///   - oldState: Old tracking state of the focus entity.
    func focusSquare(
        _ focusSquare: FocusSquare,
        trackingUpdated trackingState: FocusSquare.State,
        oldState: FocusSquare.State?
    )

    /// When the plane this focus entity is tracking changes. If the focus entity moves around within one plane anchor there will be no calls.
    /// - Parameters:
    ///   - focusSquare: FocusSquare object whose anchor has changed.
    ///   - planeChanged: New anchor the focus entity is tracked to.
    ///   - oldPlane: Previous anchor the focus entity is tracked
    func focusSquare(
        _ focusSquare: FocusSquare,
        planeChanged: ARPlaneAnchor?,
        oldPlane: ARPlaneAnchor?
    )
}
