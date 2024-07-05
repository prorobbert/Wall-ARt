//
//  FocusEntityDelegate+Extension.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 04/07/2024.
//

import Foundation
import ARKit

public extension FocusEntityDelegate {
    func toTrackingState() {}
    func toInitializingState() {}
    func focusEntity(
        _ focusEntity: FocusEntity, trackingUpdated trackingState: FocusEntity.State, oldState: FocusEntity.State? = nil
    ) {}
    func focusEntity(_ focusEntity: FocusEntity, planeChanged: ARPlaneAnchor?, oldPlane: ARPlaneAnchor?) {}
}
