//
//  PieceMaterials.swift
//  Chess3D
//
//  Created by Prajjwal on 06/08/26.
//
import RealityKit
internal import UIKit

enum PieceMaterials {
    // Add this static property inside enum PieceMaterials:
    static let highlight = SimpleMaterial(color: .init(red: 0.3, green: 0.7, blue: 1.0, alpha: 0.55), isMetallic: false)
    static func material(for color: PieceColor) -> SimpleMaterial {
        switch color {
        case .white:
            return SimpleMaterial(color: .init(white: 0.93, alpha: 1), roughness: 0.35, isMetallic: false)
        case .black:
            return SimpleMaterial(color: .init(white: 0.05, alpha: 1), roughness: 0.15, isMetallic: false)
        }
    }
    static let hightlight = SimpleMaterial(color: .init(red: 0.3, green: 0.7, blue: 1.0, alpha: 0.55), isMetallic: false)
}
