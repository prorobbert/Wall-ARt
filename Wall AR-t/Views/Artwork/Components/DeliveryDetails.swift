//
//  DeliveryDetails.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 13/08/2024.
//

import Domain
import SwiftUI

struct DeliveryDetails: View {

    let deliveryDetails: Delivery

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Delivery")
                .fontWeight(.semibold)
            Text("Shipping to the Netherlands")
            Text(formatPrice(deliveryDetails.price))
                .fontWeight(.semibold)
            Text("Dispatches from \(deliveryDetails.shippingFrom) within")
            Text("\(deliveryDetails.shippingDuration) working days")
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    DeliveryDetails(deliveryDetails: .mockedPreview)
        .padding(.horizontal, 20)
}
