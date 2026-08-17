//
//  GameEngine.swift
//  Chess3D
//
//  Created by Prajjwal on 06/08/26.
//
final class GameEngine {
    private(set) var board: BoardState
    private(set) var moveHistory: [Move] = []
    
    init(board: BoardState = .standardStartingPosition()) {
        self.board = board
    }
    var legalMoves: [Move] { MoveGenerator.legalMoves(for: board)}
    func legalMoves(from square: Square) -> [Move] {
        legalMoves.filter { $0.from == square }
    }
    @discardableResult
    func apply(_ move: Move) -> Bool {
        guard legalMoves.contains(move) else { return false }
        board = board.applying(move)
        moveHistory.append(move)
        return true
    }
    func reset(board: BoardState = .standardStartingPosition()) {
        self.board = board
        self.moveHistory = []
    }
    var isCheck: Bool { MoveGenerator.isKingInCheck(color: board.sideToMove, board: board) }
    var isCheckmate: Bool { MoveGenerator.isCheckmate(board: board) }
    var isStalemate: Bool { MoveGenerator.isStalemate(board: board) }
    var gameOver: Bool { isCheckmate || isStalemate }
}
