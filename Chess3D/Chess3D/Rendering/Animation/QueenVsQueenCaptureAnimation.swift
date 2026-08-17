//
//  QueenVsQueenCaptureAnimtion.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//

import RealityKit
import Foundation

struct QueenVsQueenCaptureAnimation: CaptureAnimation {
    func play(event: CaptureEvent, in scene: Entity, completion: @escaping () -> Void) {
        let attacker = event.attacker
        let defender = event.defender
        let targetPos = BoardCoordinates.worldPosition(square: event.toSquare, yOffset: 0.001)
        let midpoint = (attacker.transform.translation + defender.transform.translation) / 2
        var attackerLunge = attacker.transform
        attackerLunge.translation = midpoint
        attacker.move(to: attackerLunge, relativeTo: attacker.parent, duration: 0.18, timingFunction: .easeOut)
        var defenderRecoil = defender.transform
        defenderRecoil.translation += SIMD3<Float>(repeating: 0.01)
        defender.move(to: defenderRecoil, relativeTo: defender.parent, duration: 0.3, timingFunction: .easeIn)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            var finalPos = attacker.transform
            finalPos.translation = targetPos
            attacker.move(to: finalPos, relativeTo: attacker.parent, duration: 0.2, timingFunction: .easeInOut)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            defender.removeFromParent()
            completion()
        }
        
    }
}
