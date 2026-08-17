//
//  CaptureImpactEffect.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//

import RealityKit
internal import UIKit
enum CaptureImpactEffect {
    static func spawn(at position: SIMD3<Float>, in scene: Entity, color: UIColor = .white) {
        let effectEntity = Entity()
        effectEntity.position = position
        var particles = ParticleEmitterComponent()
        particles.emitterShape = .sphere
        particles.mainEmitter.birthRate = 120
        particles.mainEmitter.lifeSpan = 0.4
        particles.mainEmitter.color = .constant(.single(color))
        particles.mainEmitter.size = 0.02
        particles.speed = 0.6
        particles.isEmitting = true
        effectEntity.components.set(particles)
        scene.addChild(effectEntity)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            effectEntity.removeFromParent()
        }
    }
}
