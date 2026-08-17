//
//  KnightMeshBuilder.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//

import RealityKit
enum KnightMeshBuilder {
    static func build(material: RealityKit.Material) -> Entity {
        let root = Entity()
        root.name = "KnightBody"
        let baseMesh = LatheMeshGenerator.generate(profile: [
            ProfilePoint(y: 0.00, r: 0.00),
            ProfilePoint(y: 0.02, r: 0.26),
            ProfilePoint(y: 0.14, r: 0.20),
            ProfilePoint(y: 0.22, r: 0.14),
        ])
        let base = ModelEntity(mesh: baseMesh, materials: [material])
        root.addChild(base)
        let neck = ModelEntity(mesh: .generateBox(width: 0.12, height: 0.28, depth: 0.16, cornerRadius: 0.02), materials: [material])
        neck.position = [0, 0.34, -0.02]
        neck.orientation = simd_quatf(angle: .pi / 10, axis: [1, 0, 0])
        root.addChild(neck)
        let head = ModelEntity(mesh: .generateBox(width: 0.11, height: 0.14, depth: 0.24, cornerRadius: 0.02), materials: [material])
        head.position = [0, 0.46, 0.06]
        head.orientation = simd_quatf(angle: -.pi / 14, axis: [1, 0, 0])
        root.addChild(head)
        let muzzle = ModelEntity(mesh: .generateBox(width: 0.07, height: 0.07, depth: 0.10, cornerRadius: 0.015), materials: [material])
        muzzle.position = [0, 0.42, 0.17]
        root.addChild(muzzle)
        for side: Float in [-1, 1] {
            let ear = ModelEntity(mesh: .generateBox(width: 0.02, height: 0.06, depth: 0.02), materials: [material])
            ear.position = [0.03 * side, 0.54, -0.01]
            ear.orientation = simd_quatf(angle: .pi / 12 * side, axis: [0, 0, 1])
            root.addChild(ear)
        }
        return root
    }
}
