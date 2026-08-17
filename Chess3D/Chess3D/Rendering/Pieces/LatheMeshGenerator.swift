//
//  LatheMeshGenerator.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//

import RealityKit
import simd

struct ProfilePoint {
    let y: Float
    let r: Float
}

enum LatheMeshGenerator {
    static func generate(profile: [ProfilePoint], radialSegments: Int = 24) -> MeshResource {
        var positions: [SIMD3<Float>] = []
        var normals: [SIMD3<Float>] = []
        var indices: [UInt32] = []
        let angleStep = Float.pi * 2 / Float(radialSegments)
        for point in profile {
            for seg in 0..<radialSegments {
                let angle = angleStep * Float(seg)
                let x = point.r * cos(angle)
                let z = point.r * sin(angle)
                positions.append(SIMD3<Float>(x, point.y, z))
                let n = simd_normalize(SIMD3<Float>(x, 0, z))
                normals.append(point.r == 0 ? SIMD3<Float>(0, 1, 0) : n)
            }
        }
        let ringCount = profile.count
        for ring in 0..<(ringCount - 1) {
            for seg in 0..<radialSegments {
                let nextSeg = (seg + 1) % radialSegments
                let a = UInt32(ring * radialSegments + seg)
                let b = UInt32(ring * radialSegments + nextSeg)
                let c = UInt32((ring + 1) * radialSegments + seg)
                let d = UInt32((ring + 1) * radialSegments + nextSeg)
                indices.append(contentsOf:  [a, c, b])
                indices.append(contentsOf: [b, c, d])
            }
        }
        var descriptor = MeshDescriptor(name: "latheMesh")
        descriptor.positions = MeshBuffers.Positions(positions)
        descriptor.normals = MeshBuffers.Normals(normals)
        descriptor.primitives = .triangles(indices)
        return try! MeshResource.generate(from: [descriptor])
    }
    
}
