//
//  EnvironmentBuilder.swift
//  Chess3D
//
//  Created by Prajjwal on 06/08/26.
//
import SwiftUI
import RealityKit

enum EnvironmentBuilder {
    static func build() -> Entity {
        let root = Entity()
        root.name = "Environment"
        var tableMaterial = SimpleMaterial(color: .init(red: 0.25, green: 0.16, blue: 0.10, alpha: 1), roughness: 0.6, isMetallic: false)
        let table = ModelEntity(mesh: .generateBox(width: 12, height: 0.3, depth: 12, cornerRadius: 0.05), materials: [tableMaterial])
        table.position = [0, -0.35, 0]
        root.addChild(table)
        return root
    }
    static func applyImageBasedLighting(to entity: Entity) {
        if let iblResource = try? EnvironmentResource.load(named: "Studio") {
            let iblEntity = Entity()
            iblEntity.components.set(ImageBasedLightComponent(source: .single(iblResource), intensityExponent: 1.0))
            entity.addChild(iblEntity)
            entity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: iblEntity))
        }
    }
    static func buildSkybox(imageName: String = "RoomBackground360") -> Entity {
        let sphereMesh = MeshResource.generateSphere(radius: 50)
        var material = UnlitMaterial()
        if let texture = try? TextureResource.load(named: imageName) {
            material.color = .init(texture: .init(texture))
        }
        material.faceCulling = .none

        let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [material])
        sphereEntity.scale = [-1, 1, 1]   // flips the sphere inside-out so the photo faces inward, toward the camera
        sphereEntity.name = "Skybox"
        return sphereEntity
    }
 }
   

