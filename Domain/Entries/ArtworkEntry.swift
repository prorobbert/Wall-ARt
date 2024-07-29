//
//  ArtworkEntry.swift
//  Domain
//
//  Created by Robbert Ruiter on 29/07/2024.
//

import Foundation

public protocol ArtworkEntry: AnyObject, Identifiable, Equatable, Observable {
    var id: UUID { get }
    var title: String { get set }
}
