//
//  FocusEntity+Classic+Extension.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 04/07/2024.
//

import RealityKit

internal extension FocusEntity {
    // MARK: Configuration properties

    /// Original size of the focus square in meters.
    // TODO: make it customizable
    static let size: Float = 0.17
    
    static let thickness: Float = 0.018
    
    static let scaleForClosedSquare: Float = 0.97
    
    static let animationDuration = 0.7
    
    // MARK: Initialization
    
    func setupClassic(_ classicStyle: ClassicStyle) {
        /*
         The focus square consists of eight segments as follows, which can be individually animated.

             s0  s1
             _   _
         s2 |     | s3

         s4 |     | s5
             -   -
             s6  s7
         */
        let segmentCorners: [(Corner, Alignment)] = [
            (.topLeft, .horizontal), (.topRight, .horizontal),
            (.topLeft, .vertical), (.topRight, .vertical),
            (.bottomLeft, .vertical), (.bottomRight, .vertical),
            (.bottomLeft, .horizontal), (.bottomRight, .horizontal)
        ]
        self.segments = segmentCorners.enumerated().map { (index, cornerAlignment) -> Segment in
            Segment(
                name: "s\(index)", 
                corner: cornerAlignment.0,
                alignment: cornerAlignment.1,
                color: classicStyle.color
            )
        }
        
        let segmentLength: Float = 0.5
        let correction: Float = FocusEntity.thickness / 2
        segments[0].position += [-(segmentLength / 2 - correction), 0, -(segmentLength - correction)]
        segments[1].position += [segmentLength / 2 - correction, 0, -(segmentLength - correction)]
        segments[2].position += [-segmentLength, 0, -segmentLength / 2]
        segments[3].position += [segmentLength, 0, -segmentLength / 2]
        segments[4].position += [-segmentLength, 0, segmentLength / 2]
        segments[5].position += [segmentLength, 0, segmentLength / 2]
        segments[6].position += [-(segmentLength / 2 - correction), 0, segmentLength - correction]
        segments[7].position += [segmentLength / 2 - correction, 0, segmentLength - correction]
        
        for segment in segments {
            self.positioningEntity.addChild(segment)
            segment.open()
        }
        
        self.positioningEntity.scale = SIMD3<Float>(repeating: FocusEntity.size * FocusEntity.scaleForClosedSquare)
    }

    func offPlaneAnimation() {
        // Open animation
        guard !isOpen else { return }

        isOpen = true
        for segment in segments {
            segment.open()
        }

        positioningEntity.scale = .init(repeating: FocusEntity.size)
    }
    
    func onPlaneAnimation(newPlane: Bool = false) {
        guard isOpen else { return }

        self.isOpen = false
        for segment in self.segments {
            segment.close()
        }
    }
}
