//
//  FocusEntity.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 03/07/2024.
//

import Foundation
import RealityKit
import ARKit
import Combine

open class FocusEntity: Entity, HasAnchoring, HasFocusEntity {

    internal weak var arView: ARView?

    /// For moving the FocusEntity to a whole new ARView
    /// - Parameter view: The destication `ARView`
    public func moveTo(view: ARView) {
        let wasUpdating = self.isAutoUpdating
        self.setAutoUpdate(to: false)
        self.arView = view
        view.scene.addAnchor(self)
        if wasUpdating {
            self.setAutoUpdate(to: true)
        }
    }

    /// Destroy this FocusEntity and it references to any ARViews.
    /// Without calling this, your ARView could stay in memory.
    public func destroy() {
        self.setAutoUpdate(to: false)
        self.delegate = nil
        self.arView = nil
        for child in children {
            child.removeFromParent()
        }
        self.removeFromParent()
    }

    private var updateCancellable: Cancellable?
    public private(set) var isAutoUpdating: Bool = false

    /// Auto update the focus entity using `SceneEvents.Update`
    /// - Parameter autoUpdate: Boolean indicating to update the entity or not.
    public func setAutoUpdate(to autoUpdate: Bool) {
        guard autoUpdate != self.isAutoUpdating, !(autoUpdate && self.arView == nil) else { return }

        self.updateCancellable?.cancel()
        if autoUpdate {
            #if canImport(ARKit)
            self.updateCancellable = self.arView?.scene.subscribe(to: SceneEvents.Update.self, self.updateFocusEntity)
            #endif
        }
        self.isAutoUpdating = autoUpdate
    }

    public weak var delegate: FocusEntityDelegate?

    public enum State: Equatable {
        case initializing
        #if canImport(ARKit)
        case tracking(raycastResult: ARRaycastResult, camera: ARCamera?)
        #endif
    }

    /// The most recent position of the focus entity based on the current state.
    var lastPosition: SIMD3<Float>? {
        switch state {
        case .initializing: return nil
        #if canImport(ARKit)
        case .tracking(let raycastResult, _): return raycastResult.worldTransform.translation
        #endif
        }
    }

    #if canImport(ARKit)
    fileprivate func entityOffPlane(_ raycastResult: ARRaycastResult, _ camera: ARCamera?) {
        self.onPlane = false
        displayOffPlane(for: raycastResult)
    }
    #endif

    /// Current state of ``FocusEntity``
    public var state: State = .initializing {
        didSet {
            guard state != oldValue else { return }

            switch state {
            case .initializing:
                if oldValue != .initializing {
                    displayAsBillboard()
                    self.delegate?.focusEntity(self, trackingUpdated: state, oldState: oldValue)
                }
            #if canImport(ARKit)
            case let .tracking(raycastResult, camera):
                let stateChanged = oldValue == .initializing
                if stateChanged && self.anchor != nil {
                    self.anchoring = AnchoringComponent(.world(transform: Transform.identity.matrix))
                }

                let planeAnchor = raycastResult.anchor as? ARPlaneAnchor
                if let planeAnchor = planeAnchor {
                    entityOnPlane(for: raycastResult, planeAnchor: planeAnchor)
                } else {
                    entityOffPlane(raycastResult, camera)
                }

                if self.scaleEntityBasedOnDistance, let cameraTransform = self.arView?.cameraTransform {
                    self.scale = .one * scaleBasedOnDistance(cameraTransform: cameraTransform)
                }

                defer { currentPlaneAnchor = planeAnchor }
                if stateChanged {
                    self.delegate?.focusEntity(self, trackingUpdated: state, oldState: oldValue)
                }
            #endif
            }
        }
    }

    /**
    Reduce visual size change with distance by scaling up when close and down when far away.

    These adjustments result in a scale of 1.0x for a distance of 0.7 m or less
    (estimated distance when looking at a table), and a scale of 1.2x
    for a distance 1.5 m distance (estimated distance when looking at the floor).
    */
    private func scaleBasedOnDistance(cameraTransform: Transform) -> Float {
        let distanceFromCamera = simd_length(self.position(relativeTo: nil) - cameraTransform.translation)
        if distanceFromCamera < 0.7 {
            return distanceFromCamera / 0.7
        } else {
            return 0.25 * distanceFromCamera + 0.825
        }
    }

    /// Whether FocusEntity is on a plane or not.
    public internal(set) var onPlane: Bool = false
    /// Indicate if the square is currently being animated.
    public internal(set) var isAnimating = false
    /// Indicates if the square is currently changing its alignment.
    public internal(set) var isChangingAlignment = false

    /// A camera anchor used for placing the focus entity in front of the camera.
    internal var cameraAnchor: AnchorEntity!

    #if canImport(ARKit)
    /// The focus square's current alignment.
    internal var currentAlignment: ARPlaneAnchor.Alignment?

    /// The current plane anchor if the focus square is on a plane.
    public internal(set) var currentPlaneAnchor: ARPlaneAnchor? {
        didSet {
            if (oldValue == nil && self.currentPlaneAnchor == nil) || (currentPlaneAnchor == oldValue) {
                return
            }
            self.delegate?.focusEntity(self, planeChanged: currentPlaneAnchor, oldPlane: oldValue)
        }
    }
    
    /// The focus square's most recent alignments.
    internal var recentFocusEntityAlignments: [ARPlaneAnchor.Alignment] = []
    /// Previously visited plane anchors.
    internal var anchorsOfVisitedPlanes: Set<ARAnchor> = []
    #endif

    /// The focus square's most recent position.
    internal var recentFocusEntityPositions: [SIMD3<Float>] = []
    /// The primary node that controls the position of other `FocusEntity` nodes.
    internal let positioningEntity = Entity()
    internal var fillPlane: ModelEntity?

    /// Modify the scale of the focusEntity to make it slightly bigger when furher away.
    public var scaleEntityBasedOnDistance = true

    /// Create a new ``FocusEntity`` instance.
    /// - Parameters:
    ///   - arView: ARView containing the scene where the FocusEntity should be added.
    ///   - style: Style of the `FocusEntity`.
    public convenience init(on arView: ARView, style: FocusEntityComponent.Style) {
        self.init(on: arView, focus: FocusEntityComponent(style: style))
    }

    /// Create a new ``FocusEntity`` instance using the full ``FocusEntityComponent`` object.
    /// - Parameters:
    ///   - arView: ARView containing the scene where the FocusEntity should be added.
    ///   - focus: Main component for the `FocusEntity`
    public required init(on arView: ARView, focus: FocusEntityComponent) {
        self.arView = arView
        super.init()
        self.focus = focus
        self.name = "FocusEntity"
        self.orientation = simd_quatf(angle: .pi / 2, axis: [1, 0, 0])
        self.addChild(self.positioningEntity)

        cameraAnchor = AnchorEntity(.camera)
        arView.scene.addAnchor(cameraAnchor)

        // Start the focus swuare as a billboard.
        displayAsBillboard()
        self.delegate?.focusEntity(self, trackingUpdated: .initializing, oldState: nil)
        self.setAutoUpdate(to: true)
        switch self.focus.style {
        case .classic:
            guard let classicStyle = self.focus.classicStyle else { return }
            self.setupClassic(classicStyle)
        case .colored(_, _, _, let mesh):
            let fillPlane = ModelEntity(mesh: mesh)
            self.positioningEntity.addChild(fillPlane)
            self.fillPlane = fillPlane
            self.coloredStateChanged()
        }
    }

    required public init() {
        fatalError("init() has not been implemented.")
    }

    private func displayAsBillboard() {
        self.onPlane = false
        #if canImport(ARKit)
        self.currentAlignment = .none
        #endif
        stateChangedSetup()
    }

    /// Places the focus entity in front of the camera instead of on a plane.
    private func putInFrontOfCamera() {
        let newPosition = cameraAnchor.convert(position: [0, 0, -1], to: nil)
        recentFocusEntityPositions.append(newPosition)
        updatePosition()
        // Make focus entity face the camera with a smooth animation.
        var newRotation = arView?.cameraTransform.rotation ?? simd_quatf()
        newRotation *= simd_quatf(angle: .pi / 2, axis: [1, 0, 0])
        performAlignmentAnimation(to: newRotation)
    }

    #if canImport(ARKit)
    /// Called when a surface has been detected.
    private func displayOffPlane(for raycastResult: ARRaycastResult) {
        self.stateChangedSetup()
        let position = raycastResult.worldTransform.translation
        if self.currentAlignment != .none {
            recentFocusEntityPositions.append(position)
            performAlignmentAnimation(to: raycastResult.worldTransform.orientation)
        } else {
            putInFrontOfCamera()
        }

        updateTransform(raycastResult: raycastResult)
    }

    /// Called when a plance has been detected.
    private func entityOnPlane(for raycastResult: ARRaycastResult, planeAnchor: ARPlaneAnchor) {
        self.onPlane = true
        self.stateChangedSetup(newPlane: !anchorsOfVisitedPlanes.contains(planeAnchor))
        anchorsOfVisitedPlanes.insert(planeAnchor)
        let position = raycastResult.worldTransform.translation
        if self.currentAlignment != .none {
            recentFocusEntityPositions.append(position)
        } else {
            putInFrontOfCamera()
        }

        updateTransform(raycastResult: raycastResult)
    }
    
    public func updateFocusEntity(event: SceneEvents.Update? = nil) {
        // Perform hit testing only when ARKit tracking is in a good state.
        guard let camera = self.arView?.session.currentFrame?.camera,
              case .normal = camera.trackingState,
              let result = self.smartRaycast()
        else {
            // We should place the focus entity in front of the camera instead of on a plane.
            putInFrontOfCamera()
            self.state = .initializing
            return
        }

        self.state = .tracking(raycastResult: result, camera: camera)
    }
    #endif
    
    /// Called whenever the state of the focus entity changes.
    /// - Parameter newPlane: If the entity is directly on a plane, is a new plane to track
    public func stateChanged(newPlane: Bool = false) {
        switch self.focus.style {
        case .classic:
            if self.onPlane {
                self.onPlaneAnimation(newPlane: newPlane)
            } else {
                self.offPlaneAnimation()
            }
        case .colored:
            self.coloredStateChanged()
        }
    }
    
    private func stateChangedSetup(newPlane: Bool = false) {
        guard !isAnimating else { return }
        self.stateChanged(newPlane: newPlane)
    }
}
