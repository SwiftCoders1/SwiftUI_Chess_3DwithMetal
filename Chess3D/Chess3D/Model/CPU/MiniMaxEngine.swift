//
//  MiniMaxEngine.swift
//  Chess3D
//
//  Created by Prajjwal on 06/08/26.
//

enum MiniMaxEngine {
    static func bestMove(board: BoardState, depth: Int) -> Move? {
        let moves = MoveGenerator.legalMoves(for: board)
        guard !moves.isEmpty else { return nil }
        var bestMove: Move? = nil
        var bestScore = board.sideToMove == .white ? Int.min : Int.max
        for move in moves {
            let resulting = board.applying(move)
            let score = minimax(board: resulting, depth: depth - 1, alpha: Int.min, beta: Int.max, maximizing: resulting.sideToMove == .white)
            if board.sideToMove == .white ? score > bestScore : score < bestScore {
                bestScore = score
                bestMove = move
            }
        }
        return bestMove
    }
    private static func minimax(board: BoardState, depth: Int, alpha: Int, beta: Int, maximizing: Bool) -> Int {
           if depth == 0 || MoveGenerator.isCheckmate(board: board) || MoveGenerator.isStalemate(board: board) {
               return PositionEvaluator.evaluate(board)
           }
        var alpha = alpha
        var beta = beta
        let moves = MoveGenerator.legalMoves(for: board)
        if maximizing {
            var best = Int.min
            for move in moves {
                let score = minimax(board: board.applying(move), depth: depth - 1, alpha: alpha, beta: beta, maximizing: false)
                best = max(best, score)
                alpha = max(alpha, best)
                if beta <= alpha {break}
            }
            return best
        }
        else {
            var best = Int.max
            for move in moves {
                let score = minimax(board: board.applying(move), depth: depth - 1, alpha: alpha, beta: beta, maximizing: true)
                best = min(best, score)
                beta = min(beta, best)
                if beta <= alpha { break }
            }
             return best
        }
    }
    
}
