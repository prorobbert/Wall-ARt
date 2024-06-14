//
//  PlacedObject.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 12/06/2024.
//

import ARKit
import RealityKit

public class PlacedObject: Entity {

    let fileName: String

    // The 3D model displayed for this object.
    private let renderContent: ModelEntity

    public static let collisionGroup = CollisionGroup(rawValue: 1 << 29)

    // The origin og the UI attached to this object.
    // The UI is gravity aligned and orientated towards the user.
    let uiOrigin = Entity()

    var affectedByPhysics = false {
        didSet {
            guard affectedByPhysics != oldValue else { return }
            if affectedByPhysics {
                components[PhysicsBodyComponent.self]!.mode = .dynamic
            } else {
                components[PhysicsBodyComponent.self]!.mode = .static
            }
        }
    }

    var isBeingDragged = false {
        didSet {
            affectedByPhysics = !isBeingDragged
        }
    }

    var positionAtLastReanchoringCheck: SIMD3<Float>?

    var atRest = false

    init(descriptor: ModelDescriptor, renderContentToClone: ModelEntity, shapes: [ShapeResource]) {
        fileName = descriptor.fileName
        renderContent = renderContentToClone.clone(recursive: true)
        super.init()
        name = renderContent.name

        // Apply the rendered content's scale to this parent entity to ensure that the scale of the collision shape and physics body are correct.
        scale = renderContent.scale
        renderContent.scale = .one

        // Make the object respond to gravity
        let physicsMaterial = PhysicsMaterialResource.generate(restitution: 0.0)
        let physicsBodyComponent = PhysicsBodyComponent(shapes: shapes, mass: 1.0, material: physicsMaterial, mode: .static)
        components.set(physicsBodyComponent)
        components.set(CollisionComponent(shapes: shapes, isStatic: false, filter: CollisionFilter(group: PlacedObject.collisionGroup, mask: .all)))
        addChild(renderContent)
        addChild(uiOrigin)
        uiOrigin.position.y = extents.y / 2 // Position the UI origin in the object's center.

        // Allow direct and indirect manipulation of placed objects.
        components.set(InputTargetComponent(allowedInputTypes: [.direct, .indirect]))

        // Add a grounding shadow to placed objects.
        renderContent.components.set(GroundingShadowComponent(castsShadow: true))
    }

    required init() {
        fatalError("`init` is unimplemented")
    }
}
