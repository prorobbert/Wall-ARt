//
//  TagsStore.swift
//  Domain
//
//  Created by Robbert Ruiter on 14/08/2024.
//

import Foundation
import Combine

public protocol TagsStore: AnyObject, Observable, ObservableObject {
    associatedtype EntryType: Tag
    var tags: [EntryType] { get }
    func addTag()
    func deleteTag(_ tag: EntryType)
    func reloadSampleData()
}
