//
//  DragState.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 12/06/2024.
//

import Foundation

public struct DragState {
    var draggedObject: PlacedObject
    var initialPosition: SIMD3<Float>
    
    @MainActor
    init(objectToDrag: PlacedObject) {
        draggedObject = objectToDrag
        initialPosition = objectToDrag.position
    }
}
