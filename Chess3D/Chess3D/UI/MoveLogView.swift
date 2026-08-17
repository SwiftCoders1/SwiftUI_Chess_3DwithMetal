//
//  MoveLogView.swift
//  Chess3D
//
//  Created by Prajjwal on 08/08/26.
//

// MoveLogView.swift
import SwiftUI

struct MoveLogView: View {
    let entries: [MoveLogEntry]   // most-recent-first, already sliced to last 8
    var onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                Text(entry.text)
                    .font(.caption.monospaced())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.black.opacity(0.35), in: RoundedRectangle(cornerRadius: 6))
                    .opacity(opacity(for: index))
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeOut(duration: 0.3), value: entries.map { $0.id })
        .onTapGesture { onTap() }
    }

    private func opacity(for indexFromTop: Int) -> Double {
        switch indexFromTop {
        case 0...4: return 1.0
        case 5: return 0.5
        case 6: return 0.15
        default: return 0.0
        }
    }
}
