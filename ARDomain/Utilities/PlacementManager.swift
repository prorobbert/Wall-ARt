//
//  PlacementManager.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 13/06/2024.
//

import Foundation
import ARKit
import RealityKit
import SwiftUI

@Observable
public final class PlacementManager {

    private let worldTracking = WorldTrackingProvider()
    private let planeDetection = PlaneDetectionProvider()

    private var planeAnchorHandler: PlaneAnchorHandler
    private var persistenceManager: PersistenceManager

    public var appState: AppState? {
        didSet {
            persistenceManager.placeableObjectsByFileName = appState?.placeableObjectByFileName ?? [:]
        }
    }

    private var currentDrag: DragState? {
        didSet {
            placementState.dragInProgress = currentDrag != nil
        }
    }

    public var placementState = PlacementState()

    public var rootEntity: Entity

    private let deviceLocation: Entity
    private let raycastOrigin: Entity
    private let placementLocation: Entity
    private weak var placementTooltip: Entity?
    public weak var dragTooltip: Entity?
    public weak var deleteButton: Entity?

    // Place objects on planes with a small gap.
    static private let placedObjectsOffsetOnPlanes: Float = 0.01
    static private let placedObjectsOffsetOnVerticalPlanes: Float = 0.03

    // Snap dragged objects to a nearby horizontal plane with +/- 4 centimeters.
    static private let snapToPlaneDistanceForDraggedObjects: Float = 0.04
    static private let snapToVerticalPlaneDistanceForDraggedObjects: Float = 0.03

    @MainActor
    public init() {
        let root = Entity()
        rootEntity = root
        placementLocation = Entity()
        deviceLocation = Entity()
        raycastOrigin = Entity()

        planeAnchorHandler = PlaneAnchorHandler(rootEntity: root)
        persistenceManager = PersistenceManager(worldTracking: worldTracking, rootEntity: root)
        persistenceManager.loadPersistendObjects()

        rootEntity.addChild(placementLocation)

        deviceLocation.addChild(raycastOrigin)

        // Angle raycast 15 degrees down.
        let raycastDownwardAngle = 15.0 * (Float.pi / 180)
        raycastOrigin.orientation = simd_quatf(angle: -raycastDownwardAngle, axis: [1.0, 0.0, 0.0])
    }

    func saveWorldAnchorsObjectsMapToDisk() {
        persistenceManager.saveWorldAnchorsObjectsMapToDisk()
    }

    @MainActor
    public func addPlacementTooltip(_ tooltip: Entity) {
        placementTooltip = tooltip

        // Add a tooltip 10 centimeters in front of the placement location to give users feedback about why they can't currently place an object.
        placementLocation.addChild(tooltip)
        tooltip.position = [0.0, 0.05, 0.01]
    }

    public func removeHighlightedObject() async {
        if let highlightedObject = placementState.highlightedObject {
            await persistenceManager.removeObject(highlightedObject)
        }
    }

    @MainActor
    public func runARKitSession() async {
        do {
            // Run a new set of providers every time when entering the immersive space.
            try await appState!.arkitSession.run([worldTracking, planeDetection])
        } catch {
            // No need to handle the error here; the app is already monitoring the session for errors.
            return
        }

        if let firstFileName = appState?.modelDescriptors.first?.fileName, let object = appState?.placeableObjectByFileName[firstFileName] {
            select(object)
        }
    }

    @MainActor
    public func collisionBegan(_ event: CollisionEvents.Began) {
        guard let selectedObject = placementState.selectedObject else { return }
        guard selectedObject.matchesCollisionEvent(event: event) else { return }

        placementState.activeCollisions += 1
    }

    @MainActor
    public func collisionEnded(_ event: CollisionEvents.Ended) {
        guard let selectedObject = placementState.selectedObject else { return }
        guard selectedObject.matchesCollisionEvent(event: event) else { return }
        guard placementState.activeCollisions > 0 else {
            print("Received a collision ended event without a corresponding collision start event.")
            return
        }

        placementState.activeCollisions -= 1
    }

    @MainActor
    public func select(_ object: PlaceableObject?) {
        if let oldSelection = placementState.selectedObject {
            // Remove the current preview entity.
            placementLocation.removeChild(oldSelection.previewEntity)

            // Handle delection. Selecting the same object again in the app deselects it.
            if oldSelection.descriptor.fileName == object?.descriptor.fileName {
                select(nil)
                return
            }
        }

        // Update state.
        placementState.selectedObject = object
        appState?.selectedFileName = object?.descriptor.fileName

        if let object {
            // Add new preview entity.
            placementLocation.addChild(object.previewEntity)
        }
    }

    @MainActor
    public func processWorldAnchorUpdated() async {
        for await anchorUpdate in worldTracking.anchorUpdates {
            persistenceManager.process(anchorUpdate)
        }
    }

    @MainActor
    public func processDeviceAnchorUpdate() async {
        await run(function: self.queryAndProcessLatestDeviceAnchor, withFrequency: 90)
    }

    @MainActor
    private func queryAndProcessLatestDeviceAnchor() async {
        // Device anchors are only available when the provider is running.
        guard worldTracking.state == .running else { return }

        let deviceAnchor = worldTracking.queryDeviceAnchor(atTimestamp: CACurrentMediaTime())

        placementState.deviceAnchorPresent = deviceAnchor != nil
        placementState.planeAnchorsPresent = !planeAnchorHandler.planeAnchors.isEmpty
        placementState.selectedObject?.previewEntity.isEnabled = placementState.shouldShowPreview

        guard let deviceAnchor, deviceAnchor.isTracked else { return }

        await updateUserFacingUIOrientations(deviceAnchor)
        await checkWhichObjectDeviceIsPointingAt(deviceAnchor)
        await updatePlacementLocation(deviceAnchor)
    }

    @MainActor
    private func updateUserFacingUIOrientations(_ deviceAnchor: DeviceAnchor) async {
        // 1. Orient the front side of the highlighted object's UI to face the user.
        if let uiOrigin = placementState.highlightedObject?.uiOrigin {
            // Set the UI to face the user (on the y-axis only).
            uiOrigin.look(at: deviceAnchor.originFromAnchorTransform.translation)
            let uiRotationOnYAxis = uiOrigin.transformMatrix(relativeTo: nil).gravityAligned.rotation
            uiOrigin.setOrientation(uiRotationOnYAxis, relativeTo: nil)
        }

        // 2. Orient each UI element to face the user.
        for entity in [placementTooltip, dragTooltip, deleteButton] {
            if let entity {
                entity.look(at: deviceAnchor.originFromAnchorTransform.translation)
            }
        }
    }

    @MainActor
    private func updatePlacementLocation(_ deviceAnchor: DeviceAnchor) async {
        deviceLocation.transform = Transform(matrix: deviceAnchor.originFromAnchorTransform)
        let originFromUprightDeviceAnchorTransform = deviceAnchor.originFromAnchorTransform.gravityAligned

        // Determine a placement location on planes in front of the device by casting a ray.

        // Cast the ray from the device origin.
        let origin: SIMD3<Float> = raycastOrigin.transformMatrix(relativeTo: nil).translation

        // Cast the ray along the negatice z-axis of the device anchors, but with a slight downward angle.
        // (The downward angle is configurable using the `raycastOrigin` orientation.)
        let direction: SIMD3<Float> = -raycastOrigin.transformMatrix(relativeTo: nil).zAxis

        // Only consider raycast results that are within 0.2 to 5 meters from the device.
        let minDistance: Float = 0.2
        let maxDistance: Float = 5

        // Only raycast against horizontal planes.
        let collisionMask = PlaneAnchor.allPlanesCollisionGroup

        var originFromPointOnPlaneTransform: Transform?
        if let result = rootEntity.scene?.raycast(origin: origin, direction: direction, length: maxDistance, query: .nearest, mask: collisionMask).first, result.distance > minDistance {
            if appState?.detectVerticalPlanes != nil && appState?.detectVerticalPlanes == true {
                if result.entity.components[CollisionComponent.self]?.filter.group == PlaneAnchor.verticalCollisionGroup {
                    // If the raycast hit a vertical plane, use that result with a small, fixed offset.
                    originFromPointOnPlaneTransform = Transform(matrix: originFromUprightDeviceAnchorTransform)
                    originFromPointOnPlaneTransform?.translation = result.position + [PlacementManager.placedObjectsOffsetOnVerticalPlanes, 0.0, 0.0]

                    // Calculate the plane axes
                    let planeTransform = result.entity.transformMatrix(relativeTo: nil)
                    // let planeXAxis = planeTransform.columns.0.xyz // Plane's X axis points to the right
                    let planeYAxis = planeTransform.columns.1.xyz // Plane's Y axis points towards you
                    let planeZAxis = -planeTransform.columns.2.xyz // Plane's Z axis points down

                    // Define the target forward and up directions
                    let targetForward = planeYAxis  // Target forward direction is plane's Y axis (towards you)
                    let targetUp = planeZAxis       // Target up direction is plane's X axis (right)

                    // Calculate the quaternion for rotation
                    let currentForward = SIMD3<Float>(0, 0, 1) // Object's current forward direction (Z axis)
                    let currentUp = SIMD3<Float>(0, 1, 0)      // Object's current up direction (Y axis)

                    // Create rotation quaternions to align the object
                    let rotationToAlignForward = simd_quatf(from: currentForward, to: targetForward)
                    let rotatedUp = simd_act(rotationToAlignForward, currentUp)
                    let rotationToAlignUp = simd_quatf(from: rotatedUp, to: targetUp)
                    let finalRotation = rotationToAlignUp * rotationToAlignForward

                    // Update the transform's rotation
                    originFromPointOnPlaneTransform?.rotation = finalRotation
                }
            } else {
                if result.entity.components[CollisionComponent.self]?.filter.group != PlaneAnchor.verticalCollisionGroup {
                    // If the raycast hit a horizontal plane, use that result with a small, fixed offset.
                    originFromPointOnPlaneTransform = Transform(matrix: originFromUprightDeviceAnchorTransform)
                    originFromPointOnPlaneTransform?.translation = result.position + [0.0, PlacementManager.placedObjectsOffsetOnPlanes, 0.0]
                }
            }
        }

        if let originFromPointOnPlaneTransform {
            placementLocation.transform = originFromPointOnPlaneTransform
            placementState.planeToProjectOnFound = true
        } else {
            // If no placement location can be determined, position the preview 50 centimeters in front of the deivce.
            let distanceFromDeviceAnchor: Float = 2
            let downwardsOffset: Float = 0.3
            var uprightDeviceAnchorFromOffsetTransform = matrix_identity_float4x4
            uprightDeviceAnchorFromOffsetTransform.translation = [0, -downwardsOffset, -distanceFromDeviceAnchor]
            let originFromOffsetTransform = originFromUprightDeviceAnchorTransform * uprightDeviceAnchorFromOffsetTransform

            placementLocation.transform = Transform(matrix: originFromOffsetTransform)
            placementState.planeToProjectOnFound = false
        }
    }

    @MainActor
    private func checkWhichObjectDeviceIsPointingAt(_ deviceAnchor: DeviceAnchor) async {
        let origin: SIMD3<Float> = raycastOrigin.transformMatrix(relativeTo: nil).translation
        let direction: SIMD3<Float> = -raycastOrigin.transformMatrix(relativeTo: nil).zAxis
        let collisionMask = PlacedObject.collisionGroup

        if let result = rootEntity.scene?.raycast(origin: origin, direction: direction, query: .nearest, mask: collisionMask).first {
            if let pointedAtObject = persistenceManager.object(for: result.entity) {
                setHighlightedObject(pointedAtObject)
            } else {
                setHighlightedObject(nil)
            }
        } else {
            setHighlightedObject(nil)
        }
    }

    @MainActor
    func setHighlightedObject(_ objectToHighlight: PlacedObject?) {
        guard placementState.highlightedObject != objectToHighlight else {
            return
        }
        placementState.highlightedObject = objectToHighlight

        // Detach UI from the previously highlighted object.
        guard let deleteButton, let dragTooltip else { return }
        deleteButton.removeFromParent()
        dragTooltip.removeFromParent()

        guard let objectToHighlight else { return }

        // Position and attach the UI to the newly highlighted object.
        let extents = objectToHighlight.extents
        let topLeftCorner: SIMD3<Float> = [-extents.x / 2, (extents.y / 2) + 0.02, 0]
        let frontBottomCenter: SIMD3<Float> = [0, (-extents.y / 2) + 0.04, extents.z / 2 + 0.04]
        deleteButton.position = topLeftCorner
        dragTooltip.position = frontBottomCenter

        objectToHighlight.uiOrigin.addChild(deleteButton)
        deleteButton.scale = 1 / objectToHighlight.scale
        objectToHighlight.uiOrigin.addChild(dragTooltip)
        dragTooltip.scale = 1 / objectToHighlight.scale
    }

    public func removeAllPlacedObjects() async {
        await persistenceManager.removeAllPlacedObjects()
    }

    public func processPlaneDetectionUpdates() async {
        for await anchorUpdate in planeDetection.anchorUpdates {
            await planeAnchorHandler.process(anchorUpdate)
        }
    }

    @MainActor
    public func placeSelectedObject() {
        // Ensure there's a placeable object.
        guard let objectToPlace = placementState.objectToPlace else { return }

        let object = objectToPlace.materialize()
        object.position = placementLocation.position
        object.orientation = placementLocation.orientation

        Task {
            await persistenceManager.attachObjectToWorldAnchor(object)
        }
        placementState.userPlacedAnObject = true
    }

    @MainActor
    public func checkIfAnchoredObjectsNeedToBeDetached() async {
        // Check whether objects should be detached from their world anchor.
        // This runs at 10 Hz to ensure that objects are quickly detached from their world anchor as soon as they are moved - otherwise a world anchor update could overwrite the object's position.
        await run(function: persistenceManager.checkIfAnchoredObjectsNeedToBeDetached, withFrequency: 10)
    }

    @MainActor
    public func checkIfMovingObjectsCanBeAnchored() async {
        // Check wheter objects can be reanchored.
        // This runs at 2 Hx - objects should be reanchored eventualy but it's not time critical.
        await run(function: persistenceManager.checkIfMovingObjectsCanBeAnchored, withFrequency: 2)
    }

    @MainActor
    public func updateDrag(value: EntityTargetValue<DragGesture.Value>) {
        if let currentDrag, currentDrag.draggedObject !== value.entity {
            // Make sure any previous drag ends before starting a new one.
            print("A new drag started but the previous one never ended - ending that one now.")
            endDrag()
        }

        // At the start of the drag gesture, remember which object is being manipulated.
        if currentDrag == nil {
            guard let object = persistenceManager.object(for: value.entity) else {
                print("Unable to start drag - failed to identify the dragged object.")
                return
            }

            object.isBeingDragged = true
            currentDrag = DragState(objectToDrag: object)
            placementState.userPlacedAnObject = true
        }

        // Update the dragged object's position.
        if let currentDrag {
            let initialPosition = currentDrag.initialPosition
            let translation = value.convert(value.translation3D, from: .local, to: rootEntity)

            // Update the dragged object's position with the translation along X and Z axes
            let newPosition = initialPosition + translation
            currentDrag.draggedObject.position = [initialPosition.x, newPosition.y, newPosition.z]

            if let appState, appState.detectVerticalPlanes {
                // If possible, snap the dragged object to a nearby vertical plane.
                let maxDistance = PlacementManager.snapToVerticalPlaneDistanceForDraggedObjects
                if let projectedTransform = PlaneProjector.project(
                    point: currentDrag.draggedObject.transform.matrix,
                    ontoVerticalPlaneIn: planeAnchorHandler.planeAnchors,
                    withMaxDistance: maxDistance
                ) {
                    // Constrain the movement to the plane by fixing the Y coordinate
                    let fixedX = projectedTransform.translation.x
                    currentDrag.draggedObject.position = [fixedX, projectedTransform.translation.y, projectedTransform.translation.z]
                }
            } else {
                // If possible, snap the dragged object to a nearby horizontal plane.
                let maxDistance = PlacementManager.snapToPlaneDistanceForDraggedObjects
                if let projectedTransform = PlaneProjector.project(
                    point: currentDrag.draggedObject.transform.matrix,
                    ontoHorizontalPlaneIn: planeAnchorHandler.planeAnchors,
                    withMaxDistance: maxDistance
                ) {
                    currentDrag.draggedObject.position = projectedTransform.translation
                }
            }
        }
    }

    @MainActor
    public func endDrag() {
        guard let currentDrag else { return }
        currentDrag.draggedObject.isBeingDragged = false
        self.currentDrag = nil
    }
}
