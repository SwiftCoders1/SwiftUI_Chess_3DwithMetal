//
//  ScoreboardStore.swift
//  Chess3D
//
//  Created by Prajjwal on 07/08/26.
//

import Foundation


final class ScoreboardStore {
 
    static let shared = ScoreboardStore()
    private let key = "chess3D.scoreHistory"
    private(set) var history: [ScoreRecord] = []
    
    private init() {
        load()
        
    }
    func record(result: GameResult, mode: GameMode) {
        let opponentLabel: String
        switch mode {
        case .localTwoPlayer(let opponentName, _): opponentLabel = "vs \(opponentName)"
        case .vsCPU(let difficulty, _): opponentLabel = "CPU (\(difficulty.displayName))"
        }
        let record = ScoreRecord(result: result, opponent: opponentLabel, date: Date())
        history.insert(record, at: 0)
        save()
        Task {
            await RemoteScoreboardService.shared.upload(record)
        }
    }
    var summary: (wins: Int, losses: Int, draws: Int) {
        (history.filter {$0.result == .win}.count,
         history.filter {$0.result == .loss}.count,
         history.filter {$0.result == .draw}.count)
    }
//    private func save() {
//        if let data = try? JSONEncoder().encode(history) {
//            UserDefults.standard.set(data, forKey: key)
//        }
//    }
    private func save() {
           if let data = try? JSONEncoder().encode(history) {
               UserDefaults.standard.set(data, forKey: key)
           }
       }
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([ScoreRecord].self, from: data) else {return }
        history = decoded
    }
}
