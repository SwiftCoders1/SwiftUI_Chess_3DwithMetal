//
//  MoveGenerator.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//
enum MoveGenerator {

    static func legalMoves(for board: BoardState) -> [Move] {
        let pseudoMoves = pseudoLegalMoves(for: board)
        return pseudoMoves.filter { move in
            let resulting = board.applying(move)
            return !isKingInCheck(color: board.sideToMove, board: resulting)
        }
    }

    static func isCheckmate(board: BoardState) -> Bool {
        isKingInCheck(color: board.sideToMove, board: board) && legalMoves(for: board).isEmpty
    }

    static func isStalemate(board: BoardState) -> Bool {
        !isKingInCheck(color: board.sideToMove, board: board) && legalMoves(for: board).isEmpty
    }

    static func isKingInCheck(color: PieceColor, board: BoardState) -> Bool {
        guard let kingSquare = board.squares.first(where: { $0.value.type == .king && $0.value.color == color })?.key else {
            return false
        }
        let opponent: PieceColor = color == .white ? .black : .white
        return isSquareAttacked(kingSquare, by: opponent, board: board)
    }

    private static func isSquareAttacked(_ square: Square, by color: PieceColor, board: BoardState) -> Bool {
        let pawnDir = color == .white ? 1 : -1
        for df in [-1, 1] {
            let s = Square(file: square.file - df, rank: square.rank - pawnDir)
            if s.isValid, let p = board.piece(at: s), p.color == color, p.type == .pawn { return true }
        }
        let knightOffsets = [(1,2),(2,1),(-1,2),(-2,1),(1,-2),(2,-1),(-1,-2),(-2,-1)]
        for (df, dr) in knightOffsets {
            let s = Square(file: square.file + df, rank: square.rank + dr)
            if s.isValid, let p = board.piece(at: s), p.color == color, p.type == .knight { return true }
        }
        for df in -1...1 {
            for dr in -1...1 where !(df == 0 && dr == 0) {
                let s = Square(file: square.file + df, rank: square.rank + dr)
                if s.isValid, let p = board.piece(at: s), p.color == color, p.type == .king { return true }
            }
        }
        for (df, dr) in straightDirs {
            var s = Square(file: square.file + df, rank: square.rank + dr)
            while s.isValid {
                if let p = board.piece(at: s) {
                    if p.color == color && (p.type == .rook || p.type == .queen) { return true }
                    break
                }
                s = Square(file: s.file + df, rank: s.rank + dr)
            }
        }
        for (df, dr) in diagonalDirs {
            var s = Square(file: square.file + df, rank: square.rank + dr)
            while s.isValid {
                if let p = board.piece(at: s) {
                    if p.color == color && (p.type == .bishop || p.type == .queen) { return true }
                    break
                }
                s = Square(file: s.file + df, rank: s.rank + dr)
            }
        }
        return false
    }

    private static func pseudoLegalMoves(for board: BoardState) -> [Move] {
        var moves: [Move] = []
        for (square, piece) in board.squares where piece.color == board.sideToMove {
            switch piece.type {
            case .pawn:   moves += pawnMoves(from: square, piece: piece, board: board)
            case .knight: moves += knightMoves(from: square, piece: piece, board: board)
            case .bishop: moves += slidingMoves(from: square, piece: piece, board: board, directions: diagonalDirs)
            case .rook:   moves += slidingMoves(from: square, piece: piece, board: board, directions: straightDirs)
            case .queen:  moves += slidingMoves(from: square, piece: piece, board: board, directions: diagonalDirs + straightDirs)
            case .king:   moves += kingMoves(from: square, piece: piece, board: board)
            }
        }
        return moves
    }

    private static let straightDirs = [(1,0), (-1,0), (0,1), (0,-1)]
    private static let diagonalDirs = [(1,1), (1,-1), (-1,1), (-1,-1)]

    private static func slidingMoves(from square: Square, piece: Piece, board: BoardState, directions: [(Int, Int)]) -> [Move] {
        var moves: [Move] = []
        for (df, dr) in directions {
            var next = Square(file: square.file + df, rank: square.rank + dr)
            while next.isValid {
                if let occupant = board.piece(at: next) {
                    if occupant.color != piece.color {
                        moves.append(Move(from: square, to: next, isCapture: true, capturedType: occupant.type))
                    }
                    break
                }
                moves.append(Move(from: square, to: next))
                next = Square(file: next.file + df, rank: next.rank + dr)
            }
        }
        return moves
    }

    private static func knightMoves(from square: Square, piece: Piece, board: BoardState) -> [Move] {
        let offsets = [(1,2),(2,1),(-1,2),(-2,1),(1,-2),(2,-1),(-1,-2),(-2,-1)]
        return offsets.compactMap { (df, dr) -> Move? in
            let target = Square(file: square.file + df, rank: square.rank + dr)
            guard target.isValid else { return nil }
            if let occupant = board.piece(at: target) {
                guard occupant.color != piece.color else { return nil }
                return Move(from: square, to: target, isCapture: true, capturedType: occupant.type)
            }
            return Move(from: square, to: target)
        }
    }

    private static func kingMoves(from square: Square, piece: Piece, board: BoardState) -> [Move] {
        var moves: [Move] = []
        for df in -1...1 {
            for dr in -1...1 where !(df == 0 && dr == 0) {
                let target = Square(file: square.file + df, rank: square.rank + dr)
                guard target.isValid else { continue }
                if let occupant = board.piece(at: target) {
                    if occupant.color != piece.color {
                        moves.append(Move(from: square, to: target, isCapture: true, capturedType: occupant.type))
                    }
                } else {
                    moves.append(Move(from: square, to: target))
                }
            }
        }
        if !piece.hasMoved {
            let rank = square.rank
            if let rook = board.piece(at: Square(file: 7, rank: rank)), rook.type == .rook, !rook.hasMoved,
               board.piece(at: Square(file: 5, rank: rank)) == nil, board.piece(at: Square(file: 6, rank: rank)) == nil {
                moves.append(Move(from: square, to: Square(file: 6, rank: rank), isCastle: true))
            }
            if let rook = board.piece(at: Square(file: 0, rank: rank)), rook.type == .rook, !rook.hasMoved,
               board.piece(at: Square(file: 1, rank: rank)) == nil, board.piece(at: Square(file: 2, rank: rank)) == nil,
               board.piece(at: Square(file: 3, rank: rank)) == nil {
                moves.append(Move(from: square, to: Square(file: 2, rank: rank), isCastle: true))
            }
        }
        return moves
    }

    private static func pawnMoves(from square: Square, piece: Piece, board: BoardState) -> [Move] {
        var moves: [Move] = []
        let direction = piece.color == .white ? 1 : -1
        let startRank = piece.color == .white ? 1 : 6
        let promotionRank = piece.color == .white ? 7 : 0

        func addForwardOrPromotion(_ target: Square) {
            if target.rank == promotionRank {
                for promo: PieceType in [.queen, .rook, .bishop, .knight] {
                    moves.append(Move(from: square, to: target, promotion: promo))
                }
            } else {
                moves.append(Move(from: square, to: target))
            }
        }

        let oneStep = Square(file: square.file, rank: square.rank + direction)
        if oneStep.isValid, board.piece(at: oneStep) == nil {
            addForwardOrPromotion(oneStep)
            let twoStep = Square(file: square.file, rank: square.rank + direction * 2)
            if square.rank == startRank, board.piece(at: twoStep) == nil {
                moves.append(Move(from: square, to: twoStep))
            }
        }

        for df in [-1, 1] {
            let target = Square(file: square.file + df, rank: square.rank + direction)
            guard target.isValid else { continue }
            if let occupant = board.piece(at: target), occupant.color != piece.color {
                if target.rank == promotionRank {
                    for promo: PieceType in [.queen, .rook, .bishop, .knight] {
                        moves.append(Move(from: square, to: target, promotion: promo, isCapture: true, capturedType: occupant.type))
                    }
                } else {
                    moves.append(Move(from: square, to: target, isCapture: true, capturedType: occupant.type))
                }
            } else if let epTarget = board.enPassantTarget, epTarget == target {
                moves.append(Move(from: square, to: target, isCapture: true, capturedType: .pawn, isEnPassant: true))
            }
        }
        return moves
    }
}
