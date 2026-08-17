//
//  HomeView.swift
//  Chess3D
//
//  Created by Prajjwal on 07/08/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var onPlay: () -> Void
    var onScoreboard: () -> Void
    var onSettings: () -> Void
    var body: some View {
        ZStack  {
            Theme.background.ignoresSafeArea()
            VStack(spacing: Theme.spacing) {
                Text("Chess3D").font(Theme.titleFont).foregroundStyle(.white)
                if let email = authViewModel.currentUserEmail {
                    Text("Signed in as \(email)")
                        .font(Theme.bodyFont)
                        .foregroundStyle(.white.opacity(0.7))
                }
                Button("Play", action: onPlay)
                    .buttonStyle(PrimaryButtonStyle())
                Button("Scoreboard", action: onScoreboard)
                    .buttonStyle(SecondaryButtonStyle())
                Button("Settings", action: onSettings)
                    .buttonStyle(SecondaryButtonStyle())
                Button("Sign Out") {
                    Task {await authViewModel.signOut()}
                }
                .font(.caption)
                .foregroundStyle(.white.opacity(0.5))
            }
            .padding()
        }
    }
}
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.headingFont)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Theme.accent, in: RoundedRectangle(cornerRadius: Theme.cornerRadiun))
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.bodyFont)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cornerRadiun))
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}
