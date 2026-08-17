//
//  CaptureCameraDirectior.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//

import simd
import Foundation

protocol CaptureCameraDirector {
    func focus(on position: SIMD3<Float>, duration: TimeInterval)
}
