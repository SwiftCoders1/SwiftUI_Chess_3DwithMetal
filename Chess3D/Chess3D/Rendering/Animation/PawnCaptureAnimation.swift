//
//  PawnCaptureAnimation.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//
import RealityKit
import Foundation

struct PawnCaptureAnimation: CaptureAnimation {
    func play(event: CaptureEvent, in scene: Entity, completion: @escaping() -> Void) {
        let attacker = event.attacker
        let defender = event.defender
        let targetPos = BoardCoordinates.worldPosition(square: event.toSquare, yOffset: 0.001)
        var moveTransform = attacker.transform
        moveTransform.translation = targetPos
        attacker.move(to: moveTransform, relativeTo:  attacker.parent, duration: 0.35, timingFunction: .easeInOut)
        var shrink = defender.transform
        shrink.scale = .zero
        defender.move(to: shrink, relativeTo: defender.parent, duration: 0.25, timingFunction: .easeIn)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            defender.removeFromParent()
            completion()
        }
        
    }
}
