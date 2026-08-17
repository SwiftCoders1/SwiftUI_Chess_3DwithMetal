//
//  MajorCaptureAnimation.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//
import RealityKit
import Foundation
struct MajorCaptureAnimation: CaptureAnimation {
    func play(event: CaptureEvent, in scene: Entity, completion: @escaping () -> Void) {
        let attacker = event.attacker
        let defender = event.defender
        let targetPos = BoardCoordinates.worldPosition(square: event.toSquare, yOffset: 0.001)
        var slide = attacker.transform
        slide.translation = targetPos
        attacker.move(to: slide, relativeTo: attacker.parent, duration: 0.22, timingFunction: .linear)
        var launched = defender.transform
        launched.translation += SIMD3<Float>(0.3, 0.4, 0.3)
        launched.rotation = simd_quatf(angle: .pi * 2, axis: [0, 1, 0]) * defender.transform.rotation
        defender.move(to: launched, relativeTo: defender.parent, duration: 0.3, timingFunction: .easeOut)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            defender.removeFromParent()
            completion()
        }
    }
}
