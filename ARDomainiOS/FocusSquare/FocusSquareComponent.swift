//
//  FocusSquareComponent.swift
//  ARDomainiOS
//
//  Created by Robbert Ruiter on 03/07/2024.
//

import RealityKit
#if !os(macOS)
import ARKit
#endif

internal struct ClassicStyle {
    var color: MaterialColorParameter
}

/// When using colored style, first material of a mesh will be replaced with the chosen color
internal struct ColoredStyle {
    /// Color when tracking the surface of a known plane
    var onColor: MaterialColorParameter
    /// Color when tracking an estimated plane
    var offColor: MaterialColorParameter
    /// Color when no surface tracking is achieved
    var nonTrackingColor: MaterialColorParameter
    var mesh: MeshResource
}

public struct FocusSquareComponent: Component {
    /// FocusSquareComponent Style, dictating how the FocusSquare will appear in different states
    public enum Style {
        /// Default style of FocusSquare. Box that's open when not on a plane, closed when on one.
        /// - color: Color of the FocusSquare lines, default: `FocusSquareComponent.defaultColor`
        case classic(color: MaterialColorParameter = FocusSquareComponent.defaultColor)
        /// Style that changes based on state of the FocusSquare
        /// - onColor: Color when FocusSquare is tracking on a known surface.
        /// - offColor: Color when FocusSquare is tracking, but the exact surface isn't known.
        /// - nonTrackingColor: Color when FocusSquare is unable to find a plane or estimate a plane.
        /// - mesh: Optional mesh for FocusSquare, default is a 0.1m square plane.
        case colored(
            onColor: MaterialColorParameter,
            offColor: MaterialColorParameter,
            nonTrackingColor: MaterialColorParameter,
            mesh: MeshResource = MeshResource.generatePlane(width: 0.1, depth: 0.1)
        )
    }

    let style: Style
    var classicStyle: ClassicStyle? {
        switch self.style {
        case .classic(let color):
            return ClassicStyle(color: color)
        default:
            return nil
        }
    }

    var coloredStyle: ColoredStyle? {
        switch self.style {
        case .colored(let onColor, let offColor, let nonTrackingColor, let mesh):
            return ColoredStyle(
                onColor: onColor, offColor: offColor,
                nonTrackingColor: nonTrackingColor, mesh: mesh
            )
        default:
            return nil
        }
    }

    /// Default color of FocusSquare
    public static let defaultColor: MaterialColorParameter = .color(.init(red: 1, green: 0.8, blue: 0, alpha: 1))
    /// Default style of FocusSquare, using the FocusSquareComponent.Style.classic with the color FocusSquareComponent.defaultColor.
    public static let classic = FocusSquareComponent(style: .classic(color: FocusSquareComponent.defaultColor))
    /// Alternative preset for FocusSquare, using FocusSquareComponent.Style.classic.colored,
    /// with green, orange and red for the onColor, offColor and nonTrackingColor respectively
    public static let plane = FocusSquareComponent(
        style: .colored(
            onColor: .color(.green),
            offColor: .color(.orange),
            nonTrackingColor: .color(.init(red: 1, green: 0, blue: 0, alpha: 0.2)),
            mesh: FocusSquareComponent.defaultPlane
        )
    )
    public internal(set) var isOpen = true
    internal var segments: [FocusSquare.Segment] = []
    #if !os(macOS)
    public var allowedRaycasts: [ARRaycastQuery.Target] = [.existingPlaneGeometry, .estimatedPlane]
    #endif

    static var defaultPlane = MeshResource.generatePlane(
        width: 0.1, depth: 0.1
    )

    /// Create FocusSquareComponent with a given FocusSquareComponent.Style.
    /// - Parameter style: FocusSquareComponent Style, dictating how the FocusSquare will appear in different states.
    public init(style: Style) {
        self.style = style
    }
}
