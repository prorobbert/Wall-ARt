//
//  PlaceablePlane.swift
//  Domain
//
//  Created by Robbert Ruiter on 30/10/2024.
//

import Foundation

public enum CanBePlacedOn: Int, CaseIterable, Codable, Identifiable {
    case horizontal
    case vertical

    public var id: Self {
        self
    }
}
