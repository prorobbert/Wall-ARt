//
//  Array+Extensions.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 14/08/2024.
//

import Foundation

extension Array: Identifiable where Element: Identifiable {
    public var id: [Element.ID] { map({ $0.id }) }
}

extension Array {
    mutating func popFirst() -> Element? {
        guard count > 0 else { return nil }
        return remove(at: 0)
    }
}
