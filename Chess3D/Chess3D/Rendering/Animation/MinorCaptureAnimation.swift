//
//  MinorCaptureAnimation.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//
import RealityKit
import simd
import Foundation

struct MinorCaptureAnimation: CaptureAnimation {
    func play(event: CaptureEvent, in scene: Entity, completion: @escaping () -> Void) {
        let attacker = event.attacker
        let defender = event.defender
        let targetPos = BoardCoordinates.worldPosition(square: event.toSquare, yOffset: 0.001)

        // Hop arc: up, over, down onto target square
        let start = attacker.transform
        var peak = start
        peak.translation = (start.translation + targetPos) / 2
        peak.translation.y += 0.35

        var landing = start
        landing.translation = targetPos

        attacker.move(to: peak, relativeTo: attacker.parent, duration: 0.2, timingFunction: .easeOut)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            attacker.move(to: landing, relativeTo: attacker.parent, duration: 0.2, timingFunction: .easeIn)
        }

        // Defender: knocked backward + tips over (rotate 90° around a random horizontal axis)
        var fallen = defender.transform
        let axis = SIMD3<Float>(Float.random(in: -1...1), 0, Float.random(in: -1...1))
        fallen.rotation = simd_quatf(angle: .pi / 2, axis: simd_normalize(axis)) * defender.transform.rotation
        fallen.translation += SIMD3<Float>(0.15, -0.05, 0.15)
        defender.move(to: fallen, relativeTo: defender.parent, duration: 0.3, timingFunction: .easeOut)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            defender.removeFromParent()
            completion()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            ImpactPulse.play(on: attacker)
        }
    }
}
