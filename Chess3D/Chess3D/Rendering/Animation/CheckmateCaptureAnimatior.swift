//
//  CheckmateCaptureAnimatior.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//

import RealityKit
import Foundation

struct CheckmateCaptureAnimation: CaptureAnimation {
    func play(event: CaptureEvent, in scene: Entity, completion: @escaping () -> Void) {
        let attacker = event.attacker
        let defender = event.defender
        let targetPos = BoardCoordinates.worldPosition(square: event.toSquare, yOffset: 0.001)
        var step = attacker.transform
        step.translation = targetPos
        attacker.move(to: step, relativeTo: attacker.parent, duration: 0.6, timingFunction: .easeInOut)
        var toppled = defender.transform
        toppled.rotation = simd_quatf(angle: .pi / 2 , axis: [1, 0, 0]) * defender.transform.rotation
        toppled.translation.y = 0.05
        defender.move(to: toppled, relativeTo:  defender.parent, duration: 0.7, timingFunction: .easeIn)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            completion()
        }
    }
}
