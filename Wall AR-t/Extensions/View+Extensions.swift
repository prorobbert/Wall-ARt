//
//  View+Extensions.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 05/08/2024.
//

import SwiftUI
import Domain

extension View {

    /// Analytics
    func trackEvent(_ analytics: Analytics) {
        EventModifier().track(analytics: analytics)
    }

    func trackScreen(_ analytics: Analytics) -> some View {
        return self.modifier(ScreenTrackingModifier(analytics: analytics))
    }

    @ViewBuilder
    func withPageDestination() -> some View {
        self.navigationDestination(for: Page.self) { destination in
            switch destination {
            case .artwork(let artwork):
                ArtworkPage(artwork: artwork)
                    .toolbar(.hidden, for: .tabBar)
            case .artworkList(let listTitle):
                ArtworkListPage(title: listTitle)
            case .account:
                HomePage<RealArtworksStore>()
                    .toolbar(.hidden, for: .tabBar)
            }
        }
    }

    @ViewBuilder
    func redacted(reason: RedactionReasons = .placeholder, if condition: Bool) -> some View {
        if condition {
            self.redacted(reason: reason)
        } else {
            self
        }
    }

    /// Updates an external binding with the view's size
    func withSizeBinding(_ size: Binding<CGSize>) -> some View {
        self.modifier(WithSizeBinding(size: size))
    }

    func onSizeChange(_ onSizeChange: @escaping (CGSize) -> Void) -> some View {
        self.modifier(OnSizeChange(onSizeChange: onSizeChange))
    }
}

private struct WithSizeBinding: ViewModifier {
    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content
            .overlay(GeometryReader { geometry in
                Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
            })
            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                self.size = newSize
            }
    }
}

private struct OnSizeChange: ViewModifier {
    let onSizeChange: (CGSize) -> Void

    func body(content: Content) -> some View {
        content
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
            })
            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                onSizeChange(newSize)
            }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize

    static var defaultValue: Value = .zero

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
