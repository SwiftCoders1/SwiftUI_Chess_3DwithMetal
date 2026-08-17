//
//  QueenCaptureAnimation.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//
import RealityKit
import Foundation

struct QueenCaptureAnimation: CaptureAnimation {
    func play(event: CaptureEvent, in scene: Entity, completion: @escaping () -> Void) {
        let attacker = event.attacker
        let defender = event.defender
        let targetPos = BoardCoordinates.worldPosition(square: event.toSquare, yOffset: 0.001)

        // Slight windup (pull back), then fast strike to target
        let start = attacker.transform
        var windup = start
        windup.translation -= (targetPos - start.translation) * 0.15
        windup.translation.y += 0.05

        var strike = start
        strike.translation = targetPos

        attacker.move(to: windup, relativeTo: attacker.parent, duration: 0.15, timingFunction: .easeOut)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            attacker.move(to: strike, relativeTo: attacker.parent, duration: 0.18, timingFunction: .easeIn)
        }

        // Defender: shattered outward (scale down fast + arc away), most dramatic of the non-special tiers
        var shattered = defender.transform
        shattered.scale = SIMD3<Float>(repeating: 0.01)
        shattered.translation += SIMD3<Float>(0.25, 0.5, -0.25)
        defender.move(to: shattered, relativeTo: defender.parent, duration: 0.32, timingFunction: .easeIn)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            defender.removeFromParent()
            completion()
        }
    }
}
