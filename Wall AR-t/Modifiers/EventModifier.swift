//
//  EventModifier.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 05/08/2024.
//

import Foundation
import Domain
import Infuse

struct EventModifier {
    @Dependency
    private var analyticsService: AnalyticsWorker

    func track(analytics: Analytics?) {
        guard
            let analytics = analytics,
            let event = analytics.event
        else {
            return
        }

        analyticsService.set(event: event, parameters: analytics.parameters)
    }
}
