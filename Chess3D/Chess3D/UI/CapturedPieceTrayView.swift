//
//  CapturedPieceTrayView.swift
//  Chess3D
//
//  Created by Prajjwal on 08/08/26.
//

import SwiftUI

struct CapturedPieceTrayView: View {
    let capturedByWhite: [PieceType]
    let capturedByBlack: [PieceType]

    private let whiteSymbols: [PieceType: String] = [
        .pawn: "♙", .knight: "♘", .bishop: "♗", .rook: "♖", .queen: "♕", .king: "♔"
    ]
    private let blackSymbols: [PieceType: String] = [
        .pawn: "♟", .knight: "♞", .bishop: "♝", .rook: "♜", .queen: "♛", .king: "♚"
    ]

    var body: some View {
        VStack {
            Spacer()
            HStack {
                tray(pieces: capturedByBlack, symbols: whiteSymbols)
                Spacer()
                tray(pieces: capturedByWhite, symbols: blackSymbols)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 10)
        }
    }

    private func tray(pieces: [PieceType], symbols: [PieceType: String]) -> some View {
        HStack(spacing: 2) {
            ForEach(Array(pieces.enumerated()), id: \.offset) { _, type in
                Text(symbols[type] ?? "?")
                    .font(.title3)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: pieces.count)
        .padding(8)
        .background(.black.opacity(0.3), in: RoundedRectangle(cornerRadius: 10))
    }
}
