//
//  Square.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//

struct Square: Hashable, Equatable {
    var file: Int
    var rank: Int
    var isValid: Bool { (0..<8).contains(file) && (0..<8).contains(rank) }
    var algebraic: String {
        let letter = String(UnicodeScalar(UInt8(97 + file)))
        return "\(letter)\(rank + 1)"
    }
    static func from(algebraic: String) -> Square {
        let chars = Array(algebraic.lowercased())
        let file = Int(chars[0].asciiValue! - Character("a").asciiValue!)
        let rank = Int(String(chars[1]))! - 1
        return Square(file: file, rank: rank)
    }
}
