//
//  Move.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//

struct Move: Equatable {
    let from: Square
    let to: Square
    let promotion: PieceType?
    let isCapture: Bool
    let capturedType: PieceType?
    let isCastle: Bool
    let isEnPassant: Bool
    init(from: Square, to: Square, promotion: PieceType? = nil, isCapture: Bool = false, capturedType: PieceType? = nil, isCastle: Bool = false, isEnPassant: Bool = false) {
        self.from = from
        self.to = to
        self.promotion = promotion
        self.isCapture = isCapture
        self.capturedType = capturedType
        self.isCastle = isCastle
        self.isEnPassant = isEnPassant
    }
}
