//
//  PositionEvaluator.swift
//  Chess3D
//
//  Created by Prajjwal on 06/08/26.
//

enum PositionEvaluator {

    private static let pieceValues: [PieceType: Int] = [
        .pawn: 100, .knight: 320, .bishop: 330, .rook: 500, .queen: 900, .king: 20000
    ]


    static func evaluate(_ board: BoardState) -> Int {
        var score = 0
        for (square, piece) in board.squares {
            let value = pieceValues[piece.type] ?? 0
            let centerBonus = centerProximityBonus(square)
            let total = value + centerBonus
            score += piece.color == .white ? total : -total
        }
        return score
    }

  
    private static func centerProximityBonus(_ square: Square) -> Int {
        let dx = abs(square.file - 3) + abs(square.file - 4)
        let dy = abs(square.rank - 3) + abs(square.rank - 4)
        return max(0, 6 - (dx + dy))
    }
}
