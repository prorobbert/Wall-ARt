//
//  ArtworkSortOrder.swift
//  Domain
//
//  Created by Robbert Ruiter on 02/08/2024.
//

import Foundation

public enum ArtworkSortOrder: LocalizedStringResource, Identifiable, CaseIterable {
    case title = "Title"
    case artist = "Artist"
    case medium = "Medium"

    public var id: Self {
        self
    }
}
