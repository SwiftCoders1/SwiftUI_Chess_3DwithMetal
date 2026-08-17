//
//  MoveHistoryView.swift
//  Chess3D
//
//  Created by Prajjwal on 08/08/26.
//
import SwiftUI

struct MoveHistoryView: View {
    let entries: [MoveLogEntry]

    private var movePairs: [(number: Int, white: String?, black: String?)] {
        var pairs: [(Int, String?, String?)] = []
        var i = 0
        var moveNumber = 1
        while i < entries.count {
            let white = entries[i].text
            let black = (i + 1 < entries.count) ? entries[i + 1].text : nil
            pairs.append((moveNumber, white, black))
            i += 2
            moveNumber += 1
        }
        return pairs
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    Text("Move History")
                        .font(Theme.titleFont)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 16)

                    if movePairs.isEmpty {
                        Text("No moves yet")
                            .foregroundStyle(.white.opacity(0.5))
                            .padding(.top, 40)
                    } else {
                        VStack(spacing: 1) {
                            ForEach(movePairs, id: \.number) { pair in
                                HStack(spacing: 0) {
                                    Text("\(pair.number)")
                                        .font(.subheadline.monospacedDigit())
                                        .foregroundStyle(.white.opacity(0.4))
                                        .frame(width: 36, alignment: .leading)

                                    Text(pair.white ?? "—")
                                        .font(.subheadline.monospaced())
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Text(pair.black ?? "—")
                                        .font(.subheadline.monospaced())
                                        .foregroundStyle(.white.opacity(pair.black == nil ? 0.3 : 1))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Theme.cardBackground)
                            }
                        }
                    }
                }
            }
        }
    }
}
