//
//  Medium.swift
//  Domain
//
//  Created by Robbert Ruiter on 31/07/2024.
//

import Foundation

public enum Medium: String, CaseIterable, Codable {
    case oilOnCanvas = "Oil on Canvas"
    case acrylicOnCanvas = "Acrylic on Canvas"
    case watercolorOnPaper = "Watercolor on Paper"
    case digital = "Digital"
}
