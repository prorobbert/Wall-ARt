//
//  AnalyticsMapper.swift
//  Domain
//
//  Created by Robbert Ruiter on 06/08/2024.
//

import Foundation

struct AnalyticsMapper {

    func parameters(event: AnalyticsEvent, parameters: [String: Any]) -> [String: Any] {
        var defaultParameters: [String: Any] = parameters
        defaultParameters[AnalyticsKey.Event.category.rawValue] = event.eventCategory.rawValue
        return defaultParameters
    }

    func parameters(screen: AnalyticsScreen, parameters: [String: Any]) -> [String: Any] {
        var defaultParameters: [String: Any] = parameters
        defaultParameters[AnalyticsKey.Screen.screenName.rawValue] = screen.rawValue
        return defaultParameters
    }

    /**
    Convert a dictionary into a json string
    
    - parameter object: to convert to json
    - parameter format: of returned string (pretty printed or raw)
    
    - returns: a json string
    */
    public func jsonStringify(_ value: Any, prettyPrinted: Bool = false) -> String {
        if JSONSerialization.isValidJSONObject(value) {
            if let data = try? JSONSerialization.data(
                withJSONObject: value,
                options: (
                    prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : []
                )
            ) {
                if let string = NSString(
                    data: data,
                    encoding: String.Encoding.utf8.rawValue
                ) {
                    return string as String
                }
            }
        }
        return ""
    }
}
