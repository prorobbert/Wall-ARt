//
//  FocusEntityDelegate.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 04/07/2024.
//

import Foundation
import ARKit

public protocol FocusEntityDelegate: AnyObject {
    /// Called when the FocusEntity is now in world space.
    @available(*, deprecated, message: "Use focusEntity(_:trackingUpdated:oldState:) instead.")
    func toTrackingState()

    /// Called when the FocusEntity is tracking the camera.
    @available(*, deprecated, message: "Use focusEntity(_:trackingUpdated:oldState:) instead.")
    func toInitializingState()
    
    /// When the tracking state of the FocusEntity updates, this will be called every update frame.
    /// - Parameters:
    ///   - focusEntity: FocusEntity object whose tracking state has changed.
    ///   - trackingState: New tracking state of the focus entity.
    ///   - oldState: Old tracking state of the focus entity.
    func focusEntity(
        _ focusEntity: FocusEntity,
        trackingUpdated trackingState: FocusEntity.State,
        oldState: FocusEntity.State?
    )

    /// When the plane this focus entity is tracking changes. If the focus entity moves around within one plane anchor there will be no calls.
    /// - Parameters:
    ///   - focusEntity: FocusEntity object whose anchor has changed.
    ///   - planeChanged: New anchor the focus entity is tracked to.
    ///   - oldPlane: Previous anchor the focus entity is tracked
    func focusEntity(
        _ focusEntity: FocusEntity,
        planeChanged: ARPlaneAnchor?,
        oldPlane: ARPlaneAnchor?
    )
}
