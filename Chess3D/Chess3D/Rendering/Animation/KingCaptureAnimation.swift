//
//  KingCaptureAnimation.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//

import RealityKit
import Foundation

struct KingCaptureAnimation: CaptureAnimation {
    func play(event: CaptureEvent, in scene: Entity, completion: @escaping () -> Void) {
        let attacker = event.attacker
        let defender = event.defender
        let targetPos = BoardCoordinates.worldPosition(square: event.toSquare, yOffset: 0.001)
        
        var step = attacker.transform
        step.translation = targetPos
        attacker.move(to: step, relativeTo: attacker.parent, duration: 0.45, timingFunction: .easeInOut)
        var kneel = defender.transform
        kneel.scale.y += 0.05
        defender.move(to: kneel, relativeTo: defender.parent, duration:  0.4, timingFunction: .easeIn)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            defender.removeFromParent()
            completion()
        }
    }
}
