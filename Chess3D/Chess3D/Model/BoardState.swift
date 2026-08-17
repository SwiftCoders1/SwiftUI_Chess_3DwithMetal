//
//  BoardState.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//

struct BoardState {
    var squares: [Square: Piece] = [:]
    var sideToMove: PieceColor = .white
    var enPassantTarget: Square? = nil

    static func standardStartingPosition() -> BoardState {
        var board = BoardState()
        let backRank: [PieceType] = [.rook, .knight, .bishop, .queen, .king, .bishop, .knight, .rook]
        for file in 0..<8 {
            board.squares[Square(file: file, rank: 0)] = Piece(type: backRank[file], color: .white)
            board.squares[Square(file: file, rank: 1)] = Piece(type: .pawn, color: .white)
            board.squares[Square(file: file, rank: 6)] = Piece(type: .pawn, color: .black)
            board.squares[Square(file: file, rank: 7)] = Piece(type: backRank[file], color: .black)
        }
        return board
    }

    func piece(at square: Square) -> Piece? { squares[square] }

    func applying(_ move: Move) -> BoardState {
        var newBoard = self
        guard var moving = newBoard.squares[move.from] else {
            assertionFailure("applying(_:) called with no piece at \(move.from.algebraic) — engine/UI desync")
            return newBoard
        }
        if move.isEnPassant {
            newBoard.squares[Square(file: move.to.file, rank: move.from.rank)] = nil
        }
        if move.isCastle {
            let rank = move.from.rank
            if move.to.file == 6 {
                newBoard.squares[Square(file: 5, rank: rank)] = newBoard.squares[Square(file: 7, rank: rank)]
                newBoard.squares[Square(file: 7, rank: rank)] = nil
            } else if move.to.file == 2 {
                newBoard.squares[Square(file: 3, rank: rank)] = newBoard.squares[Square(file: 0, rank: rank)]
                newBoard.squares[Square(file: 0, rank: rank)] = nil
            }
        }
        if let promotion = move.promotion { moving.type = promotion }
        moving.hasMoved = true
        newBoard.squares[move.from] = nil
        newBoard.squares[move.to] = moving
        if moving.type == .pawn, abs(move.to.rank - move.from.rank) == 2 {
            newBoard.enPassantTarget = Square(file: move.from.file, rank: (move.from.rank + move.to.rank) / 2)
        } else {
            newBoard.enPassantTarget = nil
        }
        newBoard.sideToMove = sideToMove == .white ? .black : .white
        return newBoard
    }
}
