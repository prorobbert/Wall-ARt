//
//  Medium.swift
//  Domain
//
//  Created by Robbert Ruiter on 31/07/2024.
//

import Foundation

public enum Medium: Int, CaseIterable, Codable, Identifiable {
    case oilOnCanvas
    case acrylicOnCanvas
    case watercolorOnPaper
    case digital

    public var id: Self {
        self
    }

    public var label: LocalizedStringResource {
        switch self {
        case .oilOnCanvas:
            "Oil on Canvas"
        case .acrylicOnCanvas:
            "Acrylic on Canvas"
        case .watercolorOnPaper:
            "Watercolor on Paper"
        case .digital:
            "Digital"
        }
    }
}
