//
//  InGameHUDView.swift
//  Chess3D
//
//  Created by Prajjwal on 07/08/26.
//
import SwiftUI

struct InGameHUDView: View {
    let sideToMove: PieceColor
    let isCheck: Bool
    var onResign: () -> Void
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(sideToMove == .white ? "White to move" : "Black to move")
                        .font(Theme.headingFont)
                        .foregroundStyle(.black)
                    if isCheck {
                        Text("Check!")
                            .font(Theme.bodyFont)
                            .foregroundStyle(.red)
                    }
                }
                .frame(width: 160, height: 56)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Theme.cornerRadiun))

                Spacer()

                Button("Resign", action: onResign)
                    .font(Theme.headingFont)
                    .foregroundStyle(.black)
                    .frame(width: 160, height: 56)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Theme.cornerRadiun))
            }
            .padding()
            Spacer()
        }
    }
}
