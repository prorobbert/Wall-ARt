//
//  PlacementTooltip.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 13/06/2024.
//

import SwiftUI
import ARDomain

struct PlacementTooltip: View {
    var placementState: PlacementState
    var detectVerticalPlanes: Bool = false

    var body: some View {
        if let message {
            TooltipView(text: message)
        }
    }

    var message: String? {
        // Decide on a message to display, in order of importance.
        if !placementState.planeToProjectOnFound {
            if detectVerticalPlanes {
                return String(localized: "point_device_vertical_surface")
            }
            return String(localized: "point_device_horizontal_surface")
        }
        if placementState.collisionDetected {
            return String(localized: "space_occupied")
        }
        if !placementState.userPlacedAnObject {
            return String(localized: "tap_to_place_objects")
        }
        return nil
    }
}

#Preview(windowStyle: .plain) {
    VStack {
        PlacementTooltip(placementState: PlacementState())
        PlacementTooltip(placementState: PlacementState().withPlaneFound())
        PlacementTooltip(placementState: PlacementState().withPlaneFound().withCollisionDetected())
    }
}

private extension PlacementState {
    func withPlaneFound() -> PlacementState {
        planeToProjectOnFound = true
        return self
    }

    func withCollisionDetected() -> PlacementState {
        activeCollisions = 1
        return self
    }
}
