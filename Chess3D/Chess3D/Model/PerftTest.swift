//
//  PerftTest.swift
//  Chess3D
//
//  Created by Prajjwal on 08/08/26.
//

enum PerftTest {
    static func perft(depth: Int, board: BoardState) -> Int {
        if depth == 0 { return 1 }
        let moves = MoveGenerator.legalMoves(for: board)
        if depth == 1 { return moves.count }
        var count = 0
        for move in moves {
            count += perft(depth: depth - 1, board: board.applying(move))
        }
        return count
    }

    /// Call this once, read the console, compare against the known-correct values below.
    static func run() {
        let start = BoardState.standardStartingPosition()
        print("perft(1) = \(perft(depth: 1, board: start)) — should be 20")
        print("perft(2) = \(perft(depth: 2, board: start)) — should be 400")
        print("perft(3) = \(perft(depth: 3, board: start)) — should be 8902")
    }
}
