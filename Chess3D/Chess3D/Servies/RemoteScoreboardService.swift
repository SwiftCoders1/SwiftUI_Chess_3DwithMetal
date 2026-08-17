//
//  RemoteScoreboardService.swift
//  Chess3D
//
//  Created by Prajjwal on 07/08/26.
//

import Supabase
import Foundation

final class RemoteScoreboardService {
    static let shared = RemoteScoreboardService()

    func upload(_ record: ScoreRecord) async {
        guard let session = try? await SupabaseManager.client.auth.session else {
            return // not signed in — local-only, fine
        }

        struct RemoteScore: Encodable {
            let user_id: String
            let result: String
            let opponent: String
        }

        let payload = RemoteScore(user_id: session.user.id.uuidString,
                                   result: record.result.rawValue,
                                  opponent: record.opponent)

        try? await SupabaseManager.client
            .from("scores")
            .insert(payload)
            .execute()
    }
    func uploadGame(result: GameResult, opponent: String, moves: [String]) async {
        guard let session = try? await SupabaseManager.client.auth.session else { return }

        struct RemoteGame: Encodable {
            let user_id: String
            let result: String
            let opponent: String
            let moves: [String]
        }

        let payload = RemoteGame(user_id: session.user.id.uuidString, result: result.rawValue,
                                  opponent: opponent, moves: moves)
        try? await SupabaseManager.client.from("games").insert(payload).execute()
    }

    func fetchRemoteHistory() async -> [ScoreRecord] {
        guard let session = try? await SupabaseManager.client.auth.session else { return [] }

        struct RemoteRow: Decodable {
            let result: String
            let opponent: String
            let created_at: String
        }

        guard let rows: [RemoteRow] = try? await SupabaseManager.client
            .from("scores")
            .select()
            .eq("user_id", value: session.user.id.uuidString)
            .execute()
            .value else { return [] }

        let formatter = ISO8601DateFormatter()
        return rows.compactMap { row in
            guard let result = GameResult(rawValue: row.result) else { return nil }
            return ScoreRecord(result: result, opponent: row.opponent,
                                date: formatter.date(from: row.created_at) ?? Date())
        }
    }
}
