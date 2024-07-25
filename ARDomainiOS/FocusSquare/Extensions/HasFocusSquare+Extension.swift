//
//  HasFocusSquare+Extension.swift
//  ARDomainiOS
//
//  Created by Robbert Ruiter on 03/07/2024.
//

import Foundation
import RealityKit
import Combine

#if canImport(ARKit)
import ARKit
#endif

#if canImport(RealityFoundation)
import RealityFoundation
#endif

public protocol HasFocusSquare: Entity {}

public extension HasFocusSquare {
    var focus: FocusSquareComponent {
        get { self.components[FocusSquareComponent.self] ?? .classic }
        set { self.components[FocusSquareComponent.self] = newValue }
    }
    var isOpen: Bool {
        get { self.focus.isOpen }
        set { self.focus.isOpen = newValue }
    }
    internal var segments: [FocusSquare.Segment] {
        get { self.focus.segments }
        set { self.focus.segments = newValue }
    }
    #if canImport(ARKit)
    var allowedRaycasts: [ARRaycastQuery.Target] {
        get { self.focus.allowedRaycasts }
        set { self.focus.allowedRaycasts = newValue }
    }
    #endif
}
