//
//  PieceProfiles.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//

enum PieceProfiles {
    static let pawn: [ProfilePoint] = [
        ProfilePoint(y: 0.00, r: 0.00),
        ProfilePoint(y: 0.02, r: 0.22),
        ProfilePoint(y: 0.10, r: 0.20),
        ProfilePoint(y: 0.25, r: 0.12),
        ProfilePoint(y: 0.32, r: 0.10),
        ProfilePoint(y: 0.40, r: 0.16),
        ProfilePoint(y: 0.47, r: 0.00)
    ]
    static let rook: [ProfilePoint] = [
        ProfilePoint(y: 0.00, r: 0.00),
        ProfilePoint(y: 0.02, r: 0.26),
        ProfilePoint(y: 0.12, r: 0.23),
        ProfilePoint(y: 0.35, r: 0.18),
        ProfilePoint(y: 0.50, r: 0.18),
        ProfilePoint(y: 0.55, r: 0.24),
        ProfilePoint(y: 0.55, r: 0.00),
    ]
    static let bishop: [ProfilePoint] = [
        ProfilePoint(y: 0.00, r: 0.00),
        ProfilePoint(y: 0.02, r: 0.24),
        ProfilePoint(y: 0.12, r: 0.20),
        ProfilePoint(y: 0.35, r: 0.10),
        ProfilePoint(y: 0.50, r: 0.08),
        ProfilePoint(y: 0.58, r: 0.13),
        ProfilePoint(y: 0.64, r: 0.02),
        ProfilePoint(y: 0.66, r: 0.00),
    ]
    static let queen: [ProfilePoint] = [
        ProfilePoint(y: 0.00, r: 0.00),
        ProfilePoint(y: 0.02, r: 0.28),
        ProfilePoint(y: 0.14, r: 0.24),
        ProfilePoint(y: 0.40, r: 0.11),
        ProfilePoint(y: 0.58, r: 0.09),
        ProfilePoint(y: 0.66, r: 0.18),
        ProfilePoint(y: 0.72, r: 0.12),
        ProfilePoint(y: 0.75, r: 0.00),
    ]
    static let king: [ProfilePoint] = [
        ProfilePoint(y: 0.00, r: 0.00),
        ProfilePoint(y: 0.02, r: 0.28),
        ProfilePoint(y: 0.15, r: 0.24),
        ProfilePoint(y: 0.45, r: 0.11),
        ProfilePoint(y: 0.65, r: 0.10),
        ProfilePoint(y: 0.72, r: 0.16),
        ProfilePoint(y: 0.80, r: 0.03),
        ProfilePoint(y: 0.83, r: 0.00),
    ]
}
