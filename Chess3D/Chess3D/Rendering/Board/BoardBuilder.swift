//
//  BoardBuilder.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//
import RealityKit
internal import UIKit
import simd

enum BoardBuilder {
    static func build() -> Entity {
        let boardRoot = Entity()
        boardRoot.name = "Board"
        let squareSize: Float = 1.0
        let squareHeight: Float = 0.1
        let lightMat = SimpleMaterial(color: .init(white: 0.85, alpha: 1), roughness: 0.4, isMetallic: false)
        let darkMat = SimpleMaterial(color: .init(white: 0.15, alpha: 1), roughness: 0.4, isMetallic: false)
        for file in 0..<8 {
            for rank in 0..<8 {
                let mesh = MeshResource.generateBox(width: squareSize, height: squareHeight, depth: squareSize)
                let isLight = (file + rank) % 2 == 0
                let material = isLight ? lightMat : darkMat
                let square = ModelEntity(mesh: mesh, materials: [material])
                square.position = BoardCoordinates.worldPosition(file: file, rank: rank, yOffset: -squareHeight / 2)
                square.name = "square_\(fileLetter(file))\(rank + 1)"
                square.generateCollisionShapes(recursive: false)
                square.components.set(InputTargetComponent())
                boardRoot.addChild(square)
                let label = ModelEntity(
                    mesh: .generateText("\(fileLetter(file))\(rank + 1)",
                                         extrusionDepth: 0.002,
                                         font: .systemFont(ofSize: 0.13)),
                    materials: [SimpleMaterial(color: isLight ? .black : .white, isMetallic: false)]
                )
                label.orientation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0]) * simd_quatf(angle: -.pi / 2, axis: [1, 0, 0])
                label.position = [-0.30, squareHeight / 2 + 0.001, -0.30]
                square.addChild(label)
            }
        }
        return boardRoot
        
    }
    private static func fileLetter(_ file: Int) -> String {
        String(UnicodeScalar(UInt8(97 + file)))
    }
}
