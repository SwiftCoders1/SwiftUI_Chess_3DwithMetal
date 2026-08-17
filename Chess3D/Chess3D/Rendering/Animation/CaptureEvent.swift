//
//  CaptureEvent.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//
import RealityKit
struct CaptureEvent {
    let attacker: Entity
    let defender: Entity
    let attackerType: PieceType
    let defenderType: PieceType
    let toSquare: String
}
