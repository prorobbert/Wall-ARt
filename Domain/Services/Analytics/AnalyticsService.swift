//
//  AnalyticsService.swift
//  Domain
//
//  Created by Robbert Ruiter on 06/08/2024.
//

import Foundation
import Infuse

public final class AnalyticsService: AnalyticsWorker {

    @Dependency
    private var analyticsMapper: AnalyticsMapper

    private var previousScreen: AnalyticsScreen?
    private var currentScreen: AnalyticsScreen? {
        willSet {
            previousScreen = currentScreen
        }
    }

    public func set(screen: AnalyticsScreen, parameters: [String: Any] = [:]) {
        logScreen(screen: screen, parameters: parameters)
    }

    public func set(event: AnalyticsEvent, parameters: [String: Any] = [:]) {
        logEvent(event: event, parameters: parameters)
    }
}

// MARK: - Logging
private extension AnalyticsService {

    func logEvent(event: AnalyticsEvent, parameters: [String: Any] = [:]) {
        logDebugEvent(
            for: event.eventName,
            parameters: analyticsMapper.parameters(
                event: event,
                parameters: parameters
            )
        )
    }

    func logScreen(screen: AnalyticsScreen, parameters: [String: Any] = [:]) {
        guard previousScreen != screen else {
            return
        }
        currentScreen = screen

        logDebugEvent(
            for: AnalyticsKey.Screen.screenView.rawValue,
            parameters: analyticsMapper.parameters(
                screen: screen,
                parameters: parameters
            )
        )
    }
}

// MARK: - Conviva
private extension AnalyticsService {

    func logDebugEvent(for key: String, parameters: [String: Any]) {
#if DEBUG
        let data = analyticsMapper.jsonStringify(parameters)
        debugPrint("👨🏼‍💻 Analytics Event Triggered with key:", key, ", and data: ", data,", from parameters: ", parameters)
#endif
    }
}
