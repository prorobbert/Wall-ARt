//
//  RealityKitView.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 27/06/2024.
//

import SwiftUI
import RealityKit
import ARKit

struct RealityKitView: UIViewRepresentable {
    @Binding var isCoachingComplete: Bool
    private let enableEnvironmentTexturing = true
    private let enableObjectOcclusion = true
    private let enablePeopleOcclusion = true

    func makeUIView(context: Context) -> ARView {
        let arView = ARView()
        let session = arView.session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.vertical]
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
        }
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) {
            config.sceneReconstruction = .meshWithClassification
        } else if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        // People occlusion
        if enablePeopleOcclusion {
            if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
                config.frameSemantics.insert(.personSegmentationWithDepth)
            }
        }
        // Run the AR session
        session.run(config, options: [.removeExistingAnchors, .resetTracking])

        // Add coaching overlay
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = session
        coachingOverlay.activatesAutomatically = true
        coachingOverlay.goal = .verticalPlane
        coachingOverlay.delegate = context.coordinator.coachingCoordinator
        arView.addSubview(coachingOverlay)

        context.coordinator.view = arView
        session.delegate = context.coordinator

        let tapGestureRecognizer = UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.handleTap(_:))
            )
        arView.addGestureRecognizer(tapGestureRecognizer)

        return arView
    }

    func updateUIView(_ view: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(coachingCoordinator: CoachingCoordinator(isCoachingComplete: $isCoachingComplete))
    }

    class CoachingCoordinator: NSObject, ARCoachingOverlayViewDelegate {
        @Binding var isCoachingComplete: Bool

        init(isCoachingComplete: Binding<Bool>) {
            _isCoachingComplete = isCoachingComplete
        }

        func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
            isCoachingComplete = true
            print("coaching completed")
        }

        func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
            isCoachingComplete = false
            print("coaching will start")
        }
    }

    class Coordinator: NSObject, ARSessionDelegate {
        weak var view: ARView?
        var coachingCoordinator: CoachingCoordinator

        init(coachingCoordinator: CoachingCoordinator) {
            print("coordinator init")
            self.coachingCoordinator = coachingCoordinator
        }

        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let view = sender.view as? ARView else { return }
            if !coachingCoordinator.isCoachingComplete { return }
            let location = sender.location(in: view)
            print("You tapped the screen at location: \(location)")
            let raycastResults = view.raycast(from: location, allowing: .estimatedPlane, alignment: .vertical)
            guard let firstResult = raycastResults.first else { return }
            let position = simd_make_float3(firstResult.worldTransform.columns.3)
            print("This would be the following on the plane: \(position)")
            do {
//                let canvas = try ModelEntity.loadModel(named: "Statues")
//                canvas.scale = [0.002, 0.002, 0.002]
//                model.look(at: view.cameraTransform.translation, from: position, relativeTo: nil)

                guard let artTexture = getArtMaterial(name: "Senna") else { return }
                let mesh = MeshResource.generateBox(width: 1, height: 1.5, depth: 0.1)
                let canvas = ModelEntity(mesh: mesh, materials: [artTexture])
//                canvas.look(at: view.cameraTransform.translation, from: position, relativeTo: nil)
                var transform = Transform(matrix: firstResult.worldTransform)

//                transform.rotation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0])
//                canvas.transform = transform
                let targetRotation = simd_quatf(angle: .pi / 2, axis: [1, 0, 0]) * simd_quatf(angle: .pi, axis: [0, 0, 1])
                transform.rotation *= targetRotation

                canvas.transform = transform

                let anchorEntity = AnchorEntity(world: position)
                anchorEntity.addChild(canvas)
                view.scene.addAnchor(anchorEntity)
            } catch {
                print("Whoops something went wrong")
            }
        }

        private func getArtMaterial(name resourceName: String) -> PhysicallyBasedMaterial? {
            guard let texture = try? TextureResource.load(named: resourceName)
            else { return nil }
            var imageMaterial = PhysicallyBasedMaterial()
            let baseColor = MaterialParameters.Texture(texture)
            imageMaterial.baseColor = PhysicallyBasedMaterial.BaseColor(tint: .white, texture: baseColor)
            return imageMaterial
        }
    }
}
