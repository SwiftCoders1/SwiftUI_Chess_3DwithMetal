//
//  ScoreboardView.swift
//  Chess3D
//
//  Created by Prajjwal on 07/08/26.
//
// ScoreboardView.swift
import SwiftUI

struct ScoreboardView: View {
    private let store = ScoreboardStore.shared

    var body: some View {
        let summary = store.summary

        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Scoreboard")
                        .font(Theme.titleFont)
                        .foregroundStyle(.white)
                        .padding(.top, 20)

                    HStack(spacing: 16) {
                        statCard(value: summary.wins, label: "Wins", color: .green)
                        statCard(value: summary.losses, label: "Losses", color: .red)
                        statCard(value: summary.draws, label: "Draws", color: .white.opacity(0.6))
                    }

                    if store.history.isEmpty {
                        Text("No games played yet")
                            .foregroundStyle(.white.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                    } else {
                        VStack(spacing: 10) {
                            ForEach(store.history) { record in
                                historyRow(record)
                            }
                        }
                    }
                }
                .padding(20)
            }
        }
    }

    private func statCard(value: Int, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cornerRadiun))
    }

    private func historyRow(_ record: ScoreRecord) -> some View {
        HStack {
            Text(record.result.rawValue.capitalized)
                .font(.subheadline.bold())
                .foregroundStyle(resultColor(record.result))
                .frame(width: 64, alignment: .leading)

            Text(record.opponent)
                .font(.subheadline)
                .foregroundStyle(.white)

            Spacer()

            Text(record.date, style: .date)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.5))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: 12))
    }

    private func resultColor(_ result: GameResult) -> Color {
        switch result {
        case .win: return .green
        case .loss: return .red
        case .draw: return .white.opacity(0.6)
        }
    }
}
