//
//  GameModeSelectView.swift
//  Chess3D
//
//  Created by Prajjwal on 06/08/26.
//
// GameModeSelectView.swift
import SwiftUI

enum GameMode {
    case localTwoPlayer(opponentName: String, timeControl: TimeControl?)
    case vsCPU(CPUDifficulty, timeControl: TimeControl?)
}

struct GameModeSelectView: View {
    @State private var showDifficultyPicker = false
    @State private var showLocalSetup = false
    @State private var selectedDifficulty: CPUDifficulty?
    @State private var showTimeControlPicker = false
    var onModeSelected: (GameMode) -> Void

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, Color(red: 0.08, green: 0.08, blue: 0.14)],
                            startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                VStack(spacing: 6) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(Theme.accent)
                    Text("Chess3D")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 20)

                modeCard(icon: "person.2.fill", title: "1 vs 1", subtitle: "Same device, pass and play") {
                    showLocalSetup = true
                }
                modeCard(icon: "cpu", title: "vs CPU", subtitle: "Choose a difficulty") {
                    showDifficultyPicker = true
                }
            }
            .padding(32)
        }
        .sheet(isPresented: $showDifficultyPicker) {
            DifficultySelectView { difficulty in
                showDifficultyPicker = false
                selectedDifficulty = difficulty
                showTimeControlPicker = true
            }
        }
        .sheet(isPresented: $showTimeControlPicker) {
            TimeControlPickerView { timeControl in
                showTimeControlPicker = false
                if let difficulty = selectedDifficulty {
                    onModeSelected(.vsCPU(difficulty, timeControl: timeControl))
                }
            }
        }
       
    }

    private func modeCard(icon: String, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(Theme.accent)
                    .frame(width: 44, height: 44)
                    .background(Theme.accent.opacity(0.15), in: Circle())
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(Theme.headingFont).foregroundStyle(.white)
                    Text(subtitle).font(.caption).foregroundStyle(.white.opacity(0.6))
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.white.opacity(0.4))
            }
            .padding()
            .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cornerRadiun))
        }
    }
}
