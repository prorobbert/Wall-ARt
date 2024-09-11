//
//  GenerateRandomPrice.swift
//  Domain
//
//  Created by Robbert Ruiter on 10/09/2024.
//

import Foundation

//func generateRandomPrice(
//    range: ClosedRange<Double> = 80.0...9900.0,
//    randomizeDecimals: Bool = true
//) -> Double {
//    // Generate a base random number within the specified range
//    let basePrice = Double.random(in: range)
//
//    // If randomizeDecimals is true, adjust the decimals to .00, .50, or .99
//    if randomizeDecimals {
//        // Round the base price to the nearest integer
//        let roundedBasePrice = round(basePrice)
//
//        // Randomly select a decimal value: 0.00, 0.50, or 0.99
//        let decimalOptions: [Double] = [0.00, 0.50, 0.99]
//        let randomDecimal = decimalOptions.randomElement()!
//
//        // Combine the base price with the random decimal
//        return roundedBasePrice + randomDecimal
//    } else {
//        // If randomizeDecimals is false, return the original basePrice
//        return basePrice
//    }
//}

func generateRandomPrice(
    range: ClosedRange<Double> = 80.0...4900.0,
    randomizeDecimals: Bool = true,
    skewToLowerValues: Bool = true
) -> Double {
    let lowerBound = range.lowerBound
    let upperBound = range.upperBound

    // Generate a weighted random value between 0 and 1
    var randomFactor = Double.random(in: 0...1)

    // Skew the distribution to favor lower values (e.g., using square to bias toward lower range)
    if skewToLowerValues {
        randomFactor = pow(randomFactor, 5) // Adjust the power as needed for more/less skew
    }

    // Calculate the base price based on the weighted random factor
    let basePrice = lowerBound + randomFactor * (upperBound - lowerBound)

    // If randomizeDecimals is true, adjust the decimals to .00, .50, or .99
    if randomizeDecimals {
        // Round the base price to the nearest integer
        let roundedBasePrice = round(basePrice)

        // Randomly select a decimal value: 0.00, 0.50, or 0.99
        let decimalOptions: [Double] = [0.00, 0.50, 0.99]
        let randomDecimal = decimalOptions.randomElement()!

        // Combine the base price with the random decimal
        return roundedBasePrice + randomDecimal
    } else {
        // If randomizeDecimals is false, return the original basePrice
        return basePrice
    }
}
