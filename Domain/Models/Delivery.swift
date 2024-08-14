//
//  Delivery.swift
//  Domain
//
//  Created by Robbert Ruiter on 13/08/2024.
//

import Foundation
import SwiftData

@Model
public class Delivery: Identifiable, Equatable {
    @Attribute(.unique) public var id: UUID
    public var shippingFrom: String
    public var price: Double
    public var shippingDuration: Int

    public init(
        shippingFrom: String,
        price: Double,
        shippingDuration: Int
    ) {
        self.id = UUID()
        self.shippingFrom = shippingFrom
        self.price = price
        self.shippingDuration = shippingDuration
    }
}

public extension Delivery {
    static var mockedPreview: Delivery {
        let deliveryDetails = Delivery(
            shippingFrom: "France",
            price: 30.0,
            shippingDuration: 3
        )
        return deliveryDetails
    }
}
