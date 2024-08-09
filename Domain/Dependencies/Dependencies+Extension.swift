//
//  Dependencies+Extension.swift
//  Domain
//
//  Created by Robbert Ruiter on 07/08/2024.
//

import Foundation
import Infuse

extension Dependencies {
    public func setup() {
        register(AnalyticsWorker.self, { AnalyticsService() })
        register(AnalyticsMapper.self, { AnalyticsMapper() })
    }
}
