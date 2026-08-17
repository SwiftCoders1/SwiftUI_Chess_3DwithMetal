//
//  ImpactPulse.swift
//  Chess3D
//
//  Created by Prajjwal on 08/08/26.
//
// ImpactPulse.swift
import RealityKit
import Foundation

enum ImpactPulse {
    /// Brief squash-and-recover on the attacker entity — call right when it "lands" on the captured square.
    static func play(on entity: Entity) {
        let original = entity.transform
        var squashed = original
        squashed.scale = original.scale * SIMD3<Float>(1.15, 0.8, 1.15)

        entity.move(to: squashed, relativeTo: entity.parent, duration: 0.08, timingFunction: .easeOut)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            entity.move(to: original, relativeTo: entity.parent, duration: 0.12, timingFunction: .easeInOut)
        }
    }
}

