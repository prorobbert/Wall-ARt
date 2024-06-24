//
//  ModelDescriptor.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 13/06/2024.
//

import Foundation

public struct ModelDescriptor: Identifiable, Hashable {
    public let fileName: String
    public let displayName: String
    let placeableOnPlane: PlaceablePlane

    public var id: String { fileName }

    init(fileName: String, displayName: String? = nil, placeableOnPlane: PlaceablePlane = .horizontal) {
        self.fileName = fileName
        self.displayName = displayName ?? fileName
        self.placeableOnPlane = placeableOnPlane
    }
}
