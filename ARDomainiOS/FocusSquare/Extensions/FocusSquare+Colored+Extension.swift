//
//  FocusSquare+Colored+Extension.swift
//  ARDomainiOS
//
//  Created by Robbert Ruiter on 04/07/2024.
//

import RealityKit

public extension FocusSquare {

    internal func coloredStateChanged() {
        guard let coloredStyle = self.focus.coloredStyle else { return }

        var endColor: MaterialColorParameter
        if self.state == .initializing {
            endColor = coloredStyle.nonTrackingColor
        } else {
            endColor = self.onPlane ? coloredStyle.onColor : coloredStyle.offColor
        }

        if self.fillPlane?.model?.materials.count == 0 {
            self.fillPlane?.model?.materials = [SimpleMaterial()]
        }

        var modelMaterial: Material!
        if #available(iOS 15, macOS 12, *) {
            switch endColor {
            case .color(let uIColor):
                var material = PhysicallyBasedMaterial()
                material.baseColor = .init(tint: .black.withAlphaComponent(uIColor.cgColor.alpha))
                material.emissiveColor = .init(color: uIColor)
                material.emissiveIntensity = 2
                modelMaterial = material
            case .texture(let textureResource):
                var material = UnlitMaterial()
                material.color = .init(tint: .white.withAlphaComponent(0.9999), texture: .init(textureResource))
                modelMaterial = material
            @unknown default: break
            }
        } else {
            var material = UnlitMaterial(color: .clear)
            material.baseColor = endColor
            material.tintColor = .white.withAlphaComponent(0.9999)
            modelMaterial = material
        }
        self.fillPlane?.model?.materials[0] = modelMaterial
    }
}
