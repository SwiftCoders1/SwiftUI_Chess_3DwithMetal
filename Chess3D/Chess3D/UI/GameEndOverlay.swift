//
//  GameEndOverlay.swift
//  Chess3D
//
//  Created by Prajjwal on 06/08/26.
//
import SwiftUI
struct GameEndOverlay: View {
    let resultText: String
    var onRematch: () -> Void
    var onMainMenu: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text(resultText)
                .font(.largeTitle.bold())
            HStack(spacing: 16) {
                Button("Rematch", action: onRematch)
                    .buttonStyle(.borderedProminent)
                Button("Main Menu", action: onMainMenu)
                    .buttonStyle(.bordered)
            }
        }
        .padding(32)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}
