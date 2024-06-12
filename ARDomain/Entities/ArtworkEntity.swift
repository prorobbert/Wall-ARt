//
//  ArtworkEntity.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 11/06/2024.
//

import Foundation
import RealityKit
import Domain

public final class ArtworkEntity: Entity {
    public var artwork: Artwork?
    
    public init(artwork: Artwork) {
        self.artwork = artwork
    }
    
    required init() {
        
    }
}
