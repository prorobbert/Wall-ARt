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
                .appFont(.bodyEmpasized)
            Text("Shipping to the Netherlands")
                .appFont(.body)
            Text(formatPrice(deliveryDetails.price))
                .appFont(.bodyEmpasized)
            Text("Dispatches from \(deliveryDetails.shippingFrom) within")
                .appFont(.body)
            Text("\(deliveryDetails.shippingDuration) working days")
                .appFont(.bodyEmpasized)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    DeliveryDetails(deliveryDetails: .mockedPreview)
        .padding(.horizontal, 20)
}
