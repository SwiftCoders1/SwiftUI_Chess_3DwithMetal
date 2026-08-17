//
//  TimeControl.swift
//  Chess3D
//
//  Created by Prajjwal on 08/08/26.
//

import Foundation

enum TimeControl: String, CaseIterable, Identifiable, Equatable {
    case rapid5, fun15, slow30, lazy60
    var id: String { rawValue }

    var minutes: Int {
        switch self {
        case .rapid5: return 5
        case .fun15: return 15
        case .slow30: return 30
        case .lazy60: return 60
        }
    }
    var seconds: TimeInterval { TimeInterval(minutes * 60) }

    var displayName: String {
        switch self {
        case .rapid5: return "Rapid — 5 min"
        case .fun15: return "Fun — 15 min"
        case .slow30: return "Slow — 30 min"
        case .lazy60: return "Lazy — 60 min"
        }
    }
}
