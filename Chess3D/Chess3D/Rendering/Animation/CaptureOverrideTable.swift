//
//  CaptureOverrideTable.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//
import RealityKit
import Foundation


struct OverrideKey: Hashable {
    let attacker: PieceType
    let defender: PieceType
}
final class CaptureOverrideTable {
    private let overrides: [OverrideKey: CaptureAnimation] = [
        OverrideKey(attacker: .pawn, defender: .king): CheckmateCaptureAnimation(),
        OverrideKey(attacker: .knight, defender: .king): CheckmateCaptureAnimation(),
        OverrideKey(attacker: .bishop, defender: .king): CheckmateCaptureAnimation(),
        OverrideKey(attacker: .rook, defender: .king): CheckmateCaptureAnimation(),
        OverrideKey(attacker: .queen, defender: .king): CheckmateCaptureAnimation(),
        OverrideKey(attacker: .queen, defender: .queen): QueenVsQueenCaptureAnimation()
    ]
    func animation(for event: CaptureEvent) -> CaptureAnimation? {
        overrides[OverrideKey(attacker: event.attackerType, defender: event.defenderType)]
    }
}
