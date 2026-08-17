//
//  ScoreRecord.swift
//  Chess3D
//
//  Created by Prajjwal on 07/08/26.
//

import Foundation

enum GameResult: String, Codable {
    case win, loss, draw
}
struct ScoreRecord: Codable, Identifiable {
    var id: UUID = UUID()
    let result: GameResult
    let opponent: String
    let date: Date
}
