//
//  CPUDifficulty.swift
//  Chess3D
//
//  Created by Prajjwal on 06/08/26.
//
enum CPUDifficulty: String, CaseIterable, Identifiable {
    case normal, medium, hard, boss
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .normal: return "Normal"
        case .medium: return "Medium"
        case .hard: return "Hard"
        case .boss: return "Boss"
        }
    }
    var searchDepth: Int {
        switch self {
        case .normal: return 1
        case .medium: return 2
        case .hard: return 3
        case .boss: return 4
        }
    }
    var randomMoveChance: Double {
        switch self {
        case .normal: return 0.6
        case .medium: return 0.2
        case .hard: return 0.05
        case .boss: return 0.0
        }
    }
}
