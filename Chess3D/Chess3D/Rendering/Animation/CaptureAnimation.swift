//
//  CaptureAnimation.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//
import RealityKit

protocol CaptureAnimation {
    func play(event: CaptureEvent, in scene: Entity, completion: @escaping () -> Void)
}
