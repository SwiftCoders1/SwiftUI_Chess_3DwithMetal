//
//  CaptureTier.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//
enum CaptureTier: CaseIterable {
    case pawnTier
    case minorTier
    case majorTier
    case queenTier
    case kingTier
    
}

extension PieceType {
    var captureTier: CaptureTier {
        switch self {
        case .pawn: return .pawnTier
        case .knight, .bishop: return .minorTier
        case .rook: return .majorTier
        case .queen: return .queenTier
        case .king: return .kingTier
        }
    }
}
