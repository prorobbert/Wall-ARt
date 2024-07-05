//
//  FocusEnitiy+Extension+Segment.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 03/07/2024.
//

import RealityKit

internal extension FocusEntity {
    /*
     The focus square consists of eight segments as follows, which can be individually animated.

         s0  s1
         _   _
     s2 |     | s3

     s4 |     | s5
         -   -
         s6  s7
     */
    enum Corner {
        case topLeft // s0, s2
        case topRight // s1, s3
        case bottomLeft // s4, s6
        case bottomRight // s5, s7
    }

    enum Alignment {
        case horizontal // s0, s1, s6, s7
        case vertical // s2, s3, s4, s5
    }

    enum Direction {
        case up
        case down
        case left
        case right

        var reversed: Direction {
            switch self {
            case .up:
                return .down
            case .down:
                return .up
            case .left:
                return .right
            case .right:
                return .left
            }
        }
    }
    
    class Segment: Entity, HasModel {
        // MARK: Configuration and Initialization

        /// Thickness of the focus square lines in meter.
        static let thickness: Float = 0.018

        /// Length of the focus square lines in meter.
        // TODO: make this configurable per selected model
        static let length: Float = 0.5

        /// Side length of the focus segments when it is open.
        static let openLength: Float = 0.2

        let corner: Corner
        let alignment: Alignment
        let plane: ModelComponent

        init(name: String, corner: Corner, alignment: Alignment, color: MaterialColorParameter) {
            self.corner = corner
            self.alignment = alignment

            var material: Material!
            if #available(iOS 15.0, *) {
                var phMaterial = PhysicallyBasedMaterial()
                phMaterial.baseColor = .init(tint: .black)

                if case .color(let uIColor) = color {
                    phMaterial.emissiveColor = .init(color: uIColor)
                } else {
                    phMaterial.emissiveColor = .init(color: .red)
                }

                phMaterial.emissiveIntensity = 2
                material = phMaterial
            } else {
                material = UnlitMaterial(color: .red)
            }

            plane = ModelComponent(mesh: .generatePlane(width: 1, depth: 1), materials: [material])

            super.init()

            switch alignment {
            case .horizontal:
                self.scale = [Segment.length, 1, Segment.thickness]
            case .vertical:
                self.scale = [Segment.thickness, 1, Segment.length]
            }

            self.name = name
            model = plane
        }

        required init() {
            fatalError("init() has not been implemented!")
        }
        
        // MARK: Animation of open/closed
        
        var openDirection: Direction {
            switch (corner, alignment) {
            case (.topLeft, .horizontal): return .left
            case (.topLeft, .vertical): return .up
            case (.topRight, .horizontal): return .right
            case (.topRight, .vertical): return .up
            case (.bottomLeft, .horizontal): return .left
            case (.bottomLeft, .vertical): return .down
            case (.bottomRight, .horizontal): return .right
            case (.bottomRight, .vertical): return .down
            }
        }
        
        func open() {
            if alignment == .horizontal {
                self.scale[0] = Segment.openLength
            } else {
                self.scale[2] = Segment.openLength
            }

            let offset = Segment.length / 2 - Segment.openLength / 2
            updatePosition(withOffset: Float(offset), for: openDirection)
        }
        
        func close() {
            let oldLength: Float
        }
        
        private func updatePosition(withOffset offset: Float, for direction: Direction) {
            switch direction {
            case .up:
                position.z -= offset
            case .down:
                position.z += offset
            case .left:
                position.x -= offset
            case .right:
                position.x += offset
            }
        }
    }
}
