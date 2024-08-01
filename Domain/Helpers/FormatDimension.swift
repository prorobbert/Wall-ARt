//
//  FormatDimension.swift
//  Domain
//
//  Created by Robbert Ruiter on 01/08/2024.
//

import Foundation

public func formatDimension(_ value: Double) -> String {
    if value.truncatingRemainder(dividingBy: 1) == 0 {
        return String(format: "%.0f", value)
    } else {
        return String(format: "%.1f", value)
    }
}
