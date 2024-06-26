//
//  ARViewController.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 26/06/2024.
//

import UIKit
import ARKit
import RealityKit
import Combine

class ARViewController: UIViewController {
    private var arView: ARView!
    private let arCoachingView = ARCoachingOverlayView()
    
    private var arScene: ARScene?

    private let simModelPos = SIMD3<Float>(0, -0.5, 0)
    private let simModelScale = SIMD3<Float>(1.5, 1.5, 1.5)
    private let enableEnvironmentTexturing = true
    private let enableObjectOcclusion = true
    private let enablePeopleOcclusion = true

    override func loadView() {
        #if !targetEnvironment(simulator)
        if ProcessInfo.processInfo.isiOSAppOnMac {
            arView = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: false)
            arView.environment.background = ARView.Environment.Background.color(UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1))
        } else {
            arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: false)
        }
        #else
        arView = ARView(frame: .zero)
        arView.environment.background = ARView.Environment.Background.color(UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1))
        #endif

        arView.session.delegate = self
        view = arView
        
        arCoachingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        arCoachingView.session = arView.session
        arCoachingView.activatesAutomatically = true
        arCoachingView.goal = .verticalPlane
        arCoachingView.delegate = self
        arView.addSubview(arCoachingView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))

        arView.addGestureRecognizer(tap)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startARSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopARSession()
    }
}

extension ARViewController {
    func setup() {
        // temp
    }

    @objc private func tapped(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            let location = gesture.location(in: arView)

            #if !targetEnvironment(simulator)
            if !ProcessInfo.processInfo.isiOSAppOnMac {
                guard let query = arView.makeRaycastQuery(from: location, allowing: .estimatedPlane, alignment: .any) else {
                    return
                }
                let raycastResult = arView.session.raycast(query)
                if let result = raycastResult.first {
                    // [Note] result.anchor: ARAnchor? can not be casted to ARPlaneAnchor
                    // - if query's allowing is .existingPlaneInfinit, result.anchor will be ARPlaneAnchor
                    // - if query's allowing is .estimatedPlane, resutl.anchor will be nil
                    let anchorEntity = AnchorEntity(raycastResult: result)
                    placeARScene(anchorEntity)
                } else {
                    // do noting
                }
            } else {
                // Running on macOS
                if arScene == nil {
                    let anchorEntity = AnchorEntity(world: float4x4(rows: [
                        SIMD4<Float>(simModelScale.x, 0, 0, simModelPos.x),
                        SIMD4<Float>(0, simModelScale.y, 0, simModelPos.y),
                        SIMD4<Float>(0, 0, simModelScale.z, simModelPos.z),
                        SIMD4<Float>(0, 0, 0, 1)]))
                    placeARScene(anchorEntity)
                } else {
                    // do nothing
                }
            }
            #else
            if arScene == nil {
                let anchorEntity = AnchorEntity(world: float4x4(rows: [
                    SIMD4<Float>(simModelScale.x, 0, 0, simModelPos.x),
                    SIMD4<Float>(0, simModelScale.y, 0, simModelPos.y),
                    SIMD4<Float>(0, 0, simModelScale.z, simModelPos.z),
                    SIMD4<Float>(0, 0, 0, 1)]))
                placeARScene(anchorEntity)
            } else {
                // Do nothing
            }
            #endif
        } else {
            // gesture not ended yet
        }
    }

    private func placeARScene(_ anchorEntity: AnchorEntity) {
        if arScene != nil {
            removeARScene()
        }

        arView.scene.addAnchor(anchorEntity)

        arScene = ARScene(anchorEntity: anchorEntity)
        arScene?.loadModels()
    }

    private func removeARScene() {
        assert(arScene != nil)
        guard let arScene else { return }

        arView.scene.removeAnchor(arScene.anchorEntity)
        self.arScene = nil
    }

    private func startARSession() {
        #if !targetEnvironment(simulator)
        if !ProcessInfo.processInfo.isiOSAppOnMac {
            let config = ARWorldTrackingConfiguration()
            // Plane detection
            config.planeDetection = [.vertical]
            // Environment texturing
            if enableEnvironmentTexturing {
                config.environmentTexturing = .automatic
            }
            // Object occlusion
            if enableObjectOcclusion {
                arView.environment.sceneUnderstanding.options = [
                    .occlusion,
                    .physics,
                    .receivesLighting
                ]
                if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
                    config.sceneReconstruction = .mesh
                }
            }
            // People occlusion
            if enablePeopleOcclusion {
                if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
                    config.frameSemantics.insert(.personSegmentationWithDepth)
                }
            }
            // Run the AR session
            arView.session.run(config, options: [.removeExistingAnchors, .resetTracking])

            UIApplication.shared.isIdleTimerDisabled = true
        }
        #endif
    }

    private func stopARSession() {
        #if !targetEnvironment(simulator)
        if !ProcessInfo.processInfo.isiOSAppOnMac {
            arView.session.pause()
            UIApplication.shared.isIdleTimerDisabled = false
        }
        #endif
    }
}

extension ARViewController: ARSessionDelegate {
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
//    func sessionWasInterrupted(_ session: ARSession) {
//        // debugLog("AR: ARSD: ARSession was interrupted.")
//        #if DEBUG
//        arSessionStateLabel.text = "ARSession was interrupted."
//        #endif
//    }
//
//    func sessionInterruptionEnded(_ session: ARSession) {
//        // debugLog("AR: ARSD: ARSession interruption ended.")
//        #if DEBUG
//        arSessionStateLabel.text = "ARSession interruption ended."
//        #endif
//    }
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        var message = (error as NSError).localizedDescription
        if let reason = (error as NSError).localizedFailureReason {
            message += "\n\(reason)"
        }
        if let suggestion = (error as NSError).localizedRecoverySuggestion {
            message += "\n\(suggestion)"
        }

        Task { @MainActor in
            let alert = UIAlertController(title: "ARSession failed", message: message, preferredStyle: .alert)
            let reset = UIAlertAction(title: "Reset the ARSession", style: .destructive) { _ in
                self.removeARScene()
                self.startARSession()
            }
            alert.addAction(reset)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .notAvailable:
            print("Camera not available")
        case .normal:
            print("Camera is normal")
        case .limited(.initializing):
            print("Camera state: limited, initializing")
        case .limited(.relocalizing):
            print("Camera state: limited, relocalizing")
        case .limited(.excessiveMotion):
            print("Camera state: limited, excessiveMotion")
        case .limited(.insufficientFeatures):
            print("Camera state: limited, insufficientFeatures")
        default:
            print("Default camera state")
        }
    }
}

extension ARViewController: ARCoachingOverlayViewDelegate {
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        // debug log
    }

    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        // nothing
    }

    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        removeARScene()
        startARSession()
    }
}
