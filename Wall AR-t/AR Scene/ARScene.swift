//
//  ARScene.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 26/06/2024.
//

import RealityKit
import Combine

final class ARScene {
    let anchorEntity: AnchorEntity
    private var accumulatedTime: Double = 0.0
    private var loadingSubscriptions: Set<AnyCancellable> = []
//    private var animatingModels: [AnimatingModel] = []
    
    init(anchorEntity: AnchorEntity) {
        self.anchorEntity = anchorEntity
    }
    
    func loadModels() {
        anchorEntity.transform.translation = ARSceneSpec.position
        
        ARSceneSpec.models.forEach { modelSpec in
            Entity.loadAsync(named: modelSpec.fileName)
                .sink(receiveCompletion: { _ in
                    // handle error
                }, receiveValue: { [weak self] entity in
                    self?.anchorEntity.addChild(entity)
                })
                .store(in: &loadingSubscriptions)
        }
    }
}
