//
//  CaptureAnimator.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//
import RealityKit

final class CaptureAnimator {

    static let shared = CaptureAnimator()
    

    private let tierAnimations: [CaptureTier: CaptureAnimation] = [
        .pawnTier:  PawnCaptureAnimation(),
        .minorTier: MinorCaptureAnimation(),
        .majorTier: MajorCaptureAnimation(),
        .queenTier: QueenCaptureAnimation(),
        .kingTier:  KingCaptureAnimation()
    ]

    private let overrides = CaptureOverrideTable()

    /// Call this from the move engine whenever a move results in a capture.
    func handleCapture(_ event: CaptureEvent, in scene: Entity, onComplete: @escaping () -> Void) {
        
        let animation = overrides.animation(for: event) ?? tierAnimations[event.attackerType.captureTier]!
        var cameraDirector: CaptureCameraDirector? = nil
        var soundPlayer: CaptureSoundPlayer? = nil
        animation.play(event: event, in: scene) {
            onComplete()   // move engine advances turn / checks game-end only after animation finishes
        }
    }
}
