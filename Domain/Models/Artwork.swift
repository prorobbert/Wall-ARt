//
//  Artwork.swift
//  Domain
//
//  Created by Robbert Ruiter on 11/06/2024.
//

import Foundation
import SwiftData

@Model
public class Artwork: ArtworkEntry {
    public var id: UUID
    public var title: String
    
    public init(title: String) {
        self.id = UUID()
        self.title = title
    }
}
