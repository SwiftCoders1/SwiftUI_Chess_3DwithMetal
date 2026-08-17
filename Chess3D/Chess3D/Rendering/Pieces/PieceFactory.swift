//
//  PieceFactory.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//

import RealityKit
internal import UIKit
enum PieceFactory {
    static func makeEntity(type: PieceType, color: PieceColor) -> Entity {
        let material = PieceMaterials.material(for: color)
        let entity: Entity
        switch type {
        case .pawn:
            entity = ModelEntity(mesh: LatheMeshGenerator.generate(profile: PieceProfiles.pawn), materials: [material])
        case .rook:
            entity = ModelEntity(mesh: LatheMeshGenerator.generate(profile: PieceProfiles.rook), materials: [material])
        case .bishop:
            entity = ModelEntity(mesh: LatheMeshGenerator.generate(profile: PieceProfiles.bishop), materials: [material])
        case .queen:
            entity = ModelEntity(mesh: LatheMeshGenerator.generate(profile: PieceProfiles.queen), materials: [material])
        case .king:
            entity = ModelEntity(mesh: LatheMeshGenerator.generate(profile: PieceProfiles.king), materials: [material])
        case .knight:
            entity = KnightMeshBuilder.build(material: material)
        }
        entity.name = "\(color)_\(type.rawValue)"
        if let model = entity as? ModelEntity {
            model.generateCollisionShapes(recursive: false)
            model.components.set(InputTargetComponent())
        } else {
            entity.generateCollisionShapes(recursive: true)
            entity.components.set(InputTargetComponent())
        }
        return entity
    }
}
