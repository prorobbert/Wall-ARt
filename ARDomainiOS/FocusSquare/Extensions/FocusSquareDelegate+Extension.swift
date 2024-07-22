//
//  FocusSquareDelegate+Extension.swift
//  ARDomainiOS
//
//  Created by Robbert Ruiter on 04/07/2024.
//

import Foundation
import ARKit

public extension FocusSquareDelegate {
    func toTrackingState() {}
    func toInitializingState() {}
    func focusSquare(
        _ focusSquare: FocusSquare, trackingUpdated trackingState: FocusSquare.State, oldState: FocusSquare.State? = nil
    ) {}
    func focusSquare(_ focusSquare: FocusSquare, planeChanged: ARPlaneAnchor?, oldPlane: ARPlaneAnchor?) {}
}
