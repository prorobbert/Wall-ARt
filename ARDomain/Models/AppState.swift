//
//  AppState.swift
//  ARDomain
//
//  Created by Robbert Ruiter on 13/06/2024.
//

import Foundation
import ARKit
import RealityKit

@Observable
public class AppState {
    public var immersiveSpaceOpened: Bool { placementManager != nil }
    private(set) public weak var placementManager: PlacementManager?

    private(set) public var placeableObjectByFileName: [String: PlaceableObject] = [:]
    private(set) public var modelDescriptors: [ModelDescriptor] = []
    public var selectedFileName: String?

    public var detectVerticalPlanes: Bool = false

    public var filteredModelDescriptors: [ModelDescriptor] {
        let newModelDescriptors = modelDescriptors.filter { descriptor in
            detectVerticalPlanes ? descriptor.placeableOnPlane == .vertical : descriptor.placeableOnPlane == .horizontal
        }

        return newModelDescriptors
    }

    public init() {}

    public func updateSelectedFileNameAfterPlaneSwitch() async {
        self.selectedFileName = filteredModelDescriptors[0].fileName
        await self.placementManager?.select(self.placeableObjectByFileName[filteredModelDescriptors[0].fileName])
    }

    public func immersiveSpaceOpened(with manager: PlacementManager) {
        placementManager = manager
    }

    public func didLeaveImmersiveSpace() {
        // Remember which placed object is attached to which persistent world anchor when leaving the immersive space.
        if let placementManager {
            placementManager.saveWorldAnchorsObjectsMapToDisk()

            // Stop the providers. The providers that just ran in the immersive space are paused now,
            // but the session doesn't need them anymore.
            // When the user reenters the immersive space, the app runs a new set of providers
            arkitSession.stop()
        }
        placementManager = nil
    }

    public func setPlaceableObjects(_ objects: [PlaceableObject]) {
        placeableObjectByFileName = objects.reduce(into: [:]) { map, placeableObject in
            map[placeableObject.descriptor.fileName] = placeableObject
        }

        // Sort descriptors alphabetically
        modelDescriptors = objects.map { $0.descriptor }.sorted { lhs, rhs in
            lhs.displayName < rhs.displayName
        }
    }

    var arkitSession = ARKitSession()
    public var providersStoppedWithError = false
    var worldSensingAuthorizationStatus = ARKitSession.AuthorizationStatus.notDetermined

    public var allRequiredAuthorizationsAreGranted: Bool {
        worldSensingAuthorizationStatus == .allowed
    }

    public var allRequiredProvidersAreSupported: Bool {
        WorldTrackingProvider.isSupported && PlaneDetectionProvider.isSupported
    }

    public var canEnterImmersiveSpace: Bool {
        allRequiredAuthorizationsAreGranted && allRequiredProvidersAreSupported
    }

    public func requestWorldSensingAuthorization() async {
        let authorizationResult = await arkitSession.requestAuthorization(for: [.worldSensing])
        worldSensingAuthorizationStatus = authorizationResult[.worldSensing]!
    }

    public func queryWorldSensingAuthorization() async {
        let authorizationResult = await arkitSession.queryAuthorization(for: [.worldSensing])
        worldSensingAuthorizationStatus = authorizationResult[.worldSensing]!
    }

    public func monitorSessionEvents() async {
        for await event in arkitSession.events {
            switch event {
            case .dataProviderStateChanged(_, let newState, let error):
                switch newState {
                case .initialized:
                    break
                case .running:
                    break
                case .paused:
                    break
                case .stopped:
                    if let error {
                        print("An error occurred: \(error)")
                        providersStoppedWithError = true
                    }
                @unknown default:
                    break
                }
            case .authorizationChanged(let type, let status):
                print("Authorization type \(type) changed to \(status)")
                if type == .worldSensing {
                    worldSensingAuthorizationStatus = status
                }
            default:
                print("An unknown event occurred: \(event)")
            }
        }
    }

    // Xcode previews
    fileprivate var previewPlacementManager: PlacementManager?

    /// An initial app state for previes in Xcode.
    @MainActor
    public static func previewAppState(immersiveSpaceOpened: Bool = false, selectedIndex: Int? = nil) -> AppState {
        let state = AppState()

        state.setPlaceableObjects([
            previewObject(named: "pancakes", placeableOnPlane: .horizontal),
            previewObject(named: "retrotv", placeableOnPlane: .horizontal),
            previewObject(named: "KingFisherSplash", placeableOnPlane: .vertical),
            previewObject(named: "Statues", placeableOnPlane: .vertical)
        ])

        if let selectedIndex, selectedIndex < state.modelDescriptors.count {
            state.selectedFileName = state.filteredModelDescriptors[selectedIndex].fileName
        }

        if immersiveSpaceOpened {
            state.previewPlacementManager = PlacementManager()
            state.placementManager = state.previewPlacementManager
        }

        return state
    }

    @MainActor
    private static func previewObject(named fileName: String, placeableOnPlane: PlaceablePlane) -> PlaceableObject {
        return PlaceableObject(
            descriptor: ModelDescriptor(fileName: fileName, placeableOnPlane: placeableOnPlane),
            previewEntity: ModelEntity(),
            renderContent: ModelEntity()
        )
    }
}
