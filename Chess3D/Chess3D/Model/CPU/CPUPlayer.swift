//
//  CPUPlayer.swift
//  Chess3D
//
//  Created by Prajjwal on 06/08/26.
//
final class CPUPlayer {
    let difficulty: CPUDifficulty
    init(difficulty: CPUDifficulty) {
        self.difficulty = difficulty
    }
    func chooseMove(board: BoardState) -> Move? {
        let legal = MoveGenerator.legalMoves(for: board)
        guard !legal.isEmpty else { return nil }
        if Double.random(in: 0...1) < difficulty.randomMoveChance {
            return legal.randomElement()
        }
        return MiniMaxEngine.bestMove(board: board, depth: difficulty.searchDepth) ?? legal.randomElement()
    }
}
