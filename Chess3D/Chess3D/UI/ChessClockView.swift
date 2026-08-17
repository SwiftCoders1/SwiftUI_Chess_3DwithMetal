//
//  ChessClockView.swift
//  Chess3D
//
//  Created by Prajjwal on 08/08/26.
//
import SwiftUI

struct ChessClockView: View {
    let whiteTime: TimeInterval
    let blackTime: TimeInterval
    let activeColor: PieceColor

    var body: some View {
        HStack(spacing: 8) {
            clockBox(time: blackTime, isActive: activeColor == .black, label: "Black")
            clockBox(time: whiteTime, isActive: activeColor == .white, label: "White")
        }
    }

    private func clockBox(time: TimeInterval, isActive: Bool, label: String) -> some View {
        VStack(spacing: 2) {
            Text(label).font(.caption2).foregroundStyle(.white.opacity(0.5))
            Text(formatted(time))
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundStyle(isActive ? .green : .white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.85), in: RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(isActive ? Color.green : .clear, lineWidth: 2))
    }

    private func formatted(_ time: TimeInterval) -> String {
        let totalTenths = Int((time * 10).rounded())
        let minutes = totalTenths / 600
        let seconds = (totalTenths / 10) % 60
        let tenths = totalTenths % 10
        return String(format: "%d:%02d.%d", minutes, seconds, tenths)
    }
}
