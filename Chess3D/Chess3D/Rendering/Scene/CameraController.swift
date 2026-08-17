//
//  CameraController.swift
//  Chess3D
//
//  Created by Prajjwal on 06/08/26.
//
import RealityKit

enum CameraController {
    static func defaultTransform() -> Transform {
        let helper = Entity()
        helper.position = [0, 6.5, -15.5]
        helper.look(at: [0, 0, 0], from: helper.position, relativeTo: nil)
        return helper.transform
    }
}
