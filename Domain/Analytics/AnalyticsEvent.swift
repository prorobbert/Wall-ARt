//
//  AnalyticsEvent.swift
//  Domain
//
//  Created by Robbert Ruiter on 05/08/2024.
//

import Foundation

public enum AnalyticsEvent {
    case artworkDetails
    case discoverOpen
    case cartOpen
    case settingsOpen
    case settingsSelect

    var eventName: String {
        switch self {
        case .artworkDetails:
            return "artwork_detail"
        case .discoverOpen:
            return "discover_open"
        case .cartOpen:
            return "cart_open"
        case .settingsOpen:
            return "settings_open"
        case .settingsSelect:
            return "settings_select"
        }
    }

    var eventCategory: AnalyticsKey.EventCategory {
        switch self {
        case .artworkDetails:
            return .artwork
        case .discoverOpen:
            return .discover
        case .cartOpen:
            return .cart
        case .settingsOpen, .settingsSelect:
            return .settings
        }
    }
}
