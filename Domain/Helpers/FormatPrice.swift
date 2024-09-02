//
//  FormatPrice.swift
//  Domain
//
//  Created by Robbert Ruiter on 13/08/2024.
//

import Foundation

public func formatPrice(_ value: Double) -> String {
    if value.truncatingRemainder(dividingBy: 1) == 0 {
        return String(format: "€%.0f", value)
    } else {
        return String(format: "€%.2f", value)
    }
}
