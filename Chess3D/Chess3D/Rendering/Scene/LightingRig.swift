//
//  LightingRig.swift
//  Chess3D
//
//  Created by Prajjwal on 06/08/26.
//

import RealityKit

enum LightingRig {
    static func build() -> Entity {
        let root = Entity()
        root.name = "LightingRig"
        let key = DirectionalLight()
        key.light.intensity = 4500
        key.light.isRealWorldProxy = false
        key.shadow = DirectionalLightComponent.Shadow(maximumDistance: 8, depthBias: 1.5)
        key.position = [2.5, 4, 2.5]
        key.look(at: .zero, from: key.position, relativeTo: nil)
        root.addChild(key)
        let rim = DirectionalLight()
        rim.light.intensity = 1800
        rim.position = [0, 3, -4]
        rim.look(at: .zero, from: rim.position, relativeTo: nil)
        root.addChild(rim)
        return root
    }
}
