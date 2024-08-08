//
//  ScreenTracking.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 08/08/2024.
//

import Domain
import Foundation
import Infuse
import SwiftUI

struct ScreenTrackingModifier: ViewModifier {

    @Dependency
    private var analyticsService: AnalyticsWorker

    /// The groups of analytics events to track
    private let analytics: Analytics

    /// Initialize with an analytics service and groups of events to be tracked by the analytics service
    init(analytics: Analytics) {
        self.analytics = analytics
    }

    func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                track(analytics)
            })
    }

    func track(_ analytics: Analytics?) {
        guard
            let analytics = analytics,
            let screen = analytics.screen
        else {
            return
        }

        analyticsService.set(screen: screen, parameters: analytics.parameters)
    }
}
