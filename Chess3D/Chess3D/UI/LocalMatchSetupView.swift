//
//  LocalMatchSetupView.swift
//  Chess3D
//
//  Created by Prajjwal on 08/08/26.
//
import SwiftUI

struct LocalMatchSetupView: View {
    @State private var opponentName = ""
    @State private var selectedTimeControl: TimeControl = .fun15
    var onStart: (String, TimeControl) -> Void

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 24) {
                Text("New 1v1 Match")
                    .font(Theme.titleFont)
                    .foregroundStyle(.white)
                    .padding(.top, 24)

                TextField("Opponent's name", text: $opponentName)
                    .padding()
                    .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cornerRadiun))
                    .foregroundStyle(.white)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Time Control").font(Theme.headingFont).foregroundStyle(.white)
                    ForEach(TimeControl.allCases) { tc in
                        Button {
                            selectedTimeControl = tc
                        } label: {
                            HStack {
                                Text(tc.displayName).foregroundStyle(.white)
                                Spacer()
                                if selectedTimeControl == tc {
                                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.accent)
                                }
                            }
                            .padding()
                            .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cornerRadiun))
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()

                Button("Start Match") {
                    let name = opponentName.trimmingCharacters(in: .whitespaces)
                    onStart(name.isEmpty ? "Player 2" : name, selectedTimeControl)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
    }
}
