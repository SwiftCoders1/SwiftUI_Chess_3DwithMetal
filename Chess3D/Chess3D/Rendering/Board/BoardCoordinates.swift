//
//  BoardCoordinates.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//

import simd

enum BoardCoordinates {
    static func indices(from square: String) -> (file: Int, rank: Int) {
        let chars = Array(square.lowercased())
        let file = Int(chars[0].asciiValue! - Character("a").asciiValue!)
        let rank = Int(String(chars[1]))! - 1
        return(file, rank)
    }
    static func worldPosition(file: Int, rank: Int, yOffset: Float = 0) -> SIMD3<Float> {
        let x = Float(file) - 3.5
        let z = Float(rank) - 3.5
        return SIMD3<Float>(x, yOffset, z)
    }
    static func worldPosition(square: String, yOffset: Float = 0) -> SIMD3<Float> {
        let (f, r) = indices(from: square)
        return worldPosition(file: f, rank: r, yOffset: yOffset)
    }
}
