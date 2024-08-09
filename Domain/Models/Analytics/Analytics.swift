//
//  Analytics.swift
//  Domain
//
//  Created by Robbert Ruiter on 05/08/2024.
//

import Foundation

public struct Analytics {

    public let screen: AnalyticsScreen?
    public let event: AnalyticsEvent?
    public let parameters: [String: Any]

    public init(screen: AnalyticsScreen? = nil, event: AnalyticsEvent? = nil, parameters: [String: Any] = [:]) {
        self.screen = screen
        self.event = event
        self.parameters = parameters
    }
}
