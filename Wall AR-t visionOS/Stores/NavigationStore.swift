//
//  NavigationStore.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 13/09/2024.
//

import Combine
import Domain
import Foundation
import SwiftUI

enum Page: Hashable {
    case artWork(Artwork)
    case artworkList(listTitle: String)
    case account
}

@MainActor
final class NavigationStore: ObservableObject {

    @Published var path: [Page] = []

    func didUpdateAppFlow() {
        popToRoot()
    }
}

extension NavigationStore {
    func push(_ path: Page) {
        self.path.append(path)
    }

    @discardableResult
    func pop() -> Page? {
        path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
