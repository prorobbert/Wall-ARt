//
//  ArtworkEdition.swift
//  Domain
//
//  Created by Robbert Ruiter on 14/08/2024.
//

import Foundation

public enum ArtworkEdition: Int, CaseIterable, Codable, Identifiable {
    case oneOfAkind
    case limitedSeries
    case producedOnDemand

    public var id: Self {
        self
    }

    public var label: LocalizedStringResource {
        switch self {
        case .oneOfAkind:
            "One of a kind"
        case .limitedSeries:
            "Limited series"
        case .producedOnDemand:
            "Can be produced on demand"
        }
    }
}
