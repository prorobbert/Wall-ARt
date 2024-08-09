//
//  AnalyticsWorker.swift
//  Domain
//
//  Created by Robbert Ruiter on 05/08/2024.
//

import Foundation

public protocol AnalyticsWorker {
    func set(screen: AnalyticsScreen, parameters: [String: Any])
    func set(event: AnalyticsEvent, parameters: [String: Any])
}
