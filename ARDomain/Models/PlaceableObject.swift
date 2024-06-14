//
//  PlaceableObject.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 13/06/2024.
//

import Foundation
import RealityKit

private enum PreviewMaterials {
    static let active = UnlitMaterial(color: .gray.withAlphaComponent(0.5))
    static let inactive = UnlitMaterial(color: .gray.withAlphaComponent(0.1))
}

@MainActor
public class PlaceableObject {
    public let descriptor: ModelDescriptor
    
    var previewEntity: Entity
    private var renderContent: ModelEntity
    
    public static let previewCollisionGroup = CollisionGroup(rawValue: 1 << 15)
    
    init(descriptor: ModelDescriptor, previewEntity: Entity, renderContent: ModelEntity) {
        self.descriptor = descriptor
        self.previewEntity = previewEntity
        self.previewEntity.applyMaterial(PreviewMaterials.active)
        self.renderContent = renderContent
    }
    
    public var isPreviewActive: Bool = true {
        didSet {
            if oldValue != isPreviewActive {
                previewEntity.applyMaterial(isPreviewActive ? PreviewMaterials.active : PreviewMaterials.inactive)
                // Only act as input target while active to prevent intercepting drag gestures from intersecting placed objects.
                previewEntity.components[InputTargetComponent.self]?.allowedInputTypes = isPreviewActive ? .indirect : []
            }
        }
    }
    
    func materialize() -> PlacedObject {
        let shapes = previewEntity.components[CollisionComponent.self]!.shapes
        return PlacedObject(descriptor: descriptor, renderContentToClone: renderContent, shapes: shapes)
    }
    
    func matchesCollisionEvent(event: CollisionEvents.Began) -> Bool {
        event.entityA == previewEntity || event.entityB == previewEntity
    }
    
    func matchesCollisionEvent(event: CollisionEvents.Ended) -> Bool {
        event.entityA == previewEntity || event.entityB == previewEntity
    }
    
    func attachPreviewEntity(to entity: Entity) {
        entity.addChild(previewEntity)
    }
}
