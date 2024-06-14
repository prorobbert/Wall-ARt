//
//  PlacementState.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 13/06/2024.
//

import Foundation
import RealityKit

@Observable
public class PlacementState {
    public init() {}

    public var selectedObject: PlaceableObject?
    var highlightedObject: PlacedObject?
    var objectToPlace: PlaceableObject? { isPlacementPossible ? selectedObject : nil }
    public var userDraggedAnObject = false

    public var planeToProjectOnFound = false

    public var activeCollisions = 0
    public var collisionDetected: Bool { activeCollisions > 0 }
    var dragInProgress = false
    public var userPlacedAnObject = false
    var deviceAnchorPresent = false
    var planeAnchorsPresent = false

    public var shouldShowPreview: Bool {
        return deviceAnchorPresent && planeAnchorsPresent && !dragInProgress && highlightedObject == nil
    }

    public var isPlacementPossible: Bool {
        return selectedObject != nil && shouldShowPreview && planeToProjectOnFound && !collisionDetected && !dragInProgress
    }
}
