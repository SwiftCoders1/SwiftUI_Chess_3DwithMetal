//
//  TimeControlPickerView.swift
//  Chess3D
//
//  Created by Prajjwal on 08/08/26.
//


import SwiftUI

struct TimeControlPickerView: View {
    var onSelected: (TimeControl?) -> Void

    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.08, blue: 0.14).ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Time Control")
                    .font(Theme.titleFont)
                    .foregroundStyle(.white)
                    .padding(.top, 24)

                ForEach(TimeControl.allCases) { tc in
                    Button {
                        onSelected(tc)
                    } label: {
                        Text(tc.displayName)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cornerRadiun))
                    }
                }

                Button {
                    onSelected(nil)
                } label: {
                    Text("No clock")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white.opacity(0.6))
                        .padding()
                        .background(Theme.cardBackground.opacity(0.5), in: RoundedRectangle(cornerRadius: Theme.cornerRadiun))
                }

                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}
