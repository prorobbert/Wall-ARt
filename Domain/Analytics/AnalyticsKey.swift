//
//  AnalyticsKey.swift
//  Domain
//
//  Created by Robbert Ruiter on 05/08/2024.
//

import Foundation

enum AnalyticsKey {
    enum Screen: String {
        case screenName = "screen_name"
        case screenView = "screen_view"
    }

    enum Event: String {
        case category = "event_category"
    }

    enum EventCategory: String {
        case artwork
        case discover
        case cart
        case profile
        case settings
    }
}
