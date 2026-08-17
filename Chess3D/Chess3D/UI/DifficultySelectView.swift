//
//  DifficultySelectView.swift
//  Chess3D
//
//  Created by Prajjwal on 06/08/26.
//
// DifficultySelectView.swift
import SwiftUI

struct DifficultySelectView: View {
    var onSelected: (CPUDifficulty) -> Void

    private let descriptions: [CPUDifficulty: String] = [
        .normal: "Mostly random moves — great for learning",
        .medium: "Thinks a couple moves ahead",
        .hard: "Solid tactical play",
        .boss: "Full-strength search — a real challenge"
    ]

    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.08, blue: 0.14).ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Choose Difficulty")
                    .font(Theme.titleFont)
                    .foregroundStyle(.white)
                    .padding(.top, 24)

                ForEach(CPUDifficulty.allCases) { level in
                    Button {
                        onSelected(level)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(level.displayName).font(Theme.headingFont).foregroundStyle(.white)
                            Text(descriptions[level] ?? "").font(.caption).foregroundStyle(.white.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cornerRadiun))
                    }
                }
                Spacer()
            }
            .padding(24)
        }
    }
}
