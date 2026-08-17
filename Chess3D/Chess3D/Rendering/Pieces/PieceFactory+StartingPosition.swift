//
//  PieceFactory+StartingPosition.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//

import RealityKit


extension PieceFactory {

    /// Standard chess starting layout.
    static func startingPosition() -> [Entity] {
        var pieces: [Entity] = []

        let backRank: [PieceType] = [.rook, .knight, .bishop, .queen, .king, .bishop, .knight, .rook]

        for file in 0..<8 {
            // White back rank (rank 1) + pawns (rank 2)
            pieces.append(place(backRank[file], .white, file: file, rank: 0))
            pieces.append(place(.pawn, .white, file: file, rank: 1))

            // Black back rank (rank 8) + pawns (rank 7)
            pieces.append(place(backRank[file], .black, file: file, rank: 7))
            pieces.append(place(.pawn, .black, file: file, rank: 6))
        }

        return pieces
    }

    private static func place(_ type: PieceType, _ color: PieceColor, file: Int, rank: Int) -> Entity {
        let entity = makeEntity(type: type, color: color)
        entity.position = BoardCoordinates.worldPosition(file: file, rank: rank, yOffset: 0.001)
        entity.name = "\(entity.name)_\(squareName(file: file, rank: rank))"
        return entity
    }

    private static func squareName(file: Int, rank: Int) -> String {
        let letter = String(UnicodeScalar(UInt8(97 + file)))
        return "\(letter)\(rank + 1)"
    }
}
