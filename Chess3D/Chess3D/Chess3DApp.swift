//
//  Chess3DApp.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//

import SwiftUI

enum AppRoute: Equatable {
    case login
    case home
    case modeSelect
    case scoreboard
    case settings
    case playing(GameMode)

    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case (.login, .login), (.home, .home), (.modeSelect, .modeSelect), (.scoreboard, .scoreboard), (.settings, .settings):
            return true
        case (.playing, .playing):
            return true
        default:
            return false
        }
    }
}

@main
struct Chess3DApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var route: AppRoute = .login

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                Group {
                    switch route {
                    case .login:
                        LoginView(onSignedIn: { route = .home })
                    case .home:
                        HomeView(onPlay: { route = .modeSelect }, onScoreboard: { route = .scoreboard }, onSettings: { route = .settings })
                    case .modeSelect:
                        GameModeSelectView { mode in
                            route = .playing(mode)
                        }
                    case .playing(let mode):
                        ChessSceneView(mode: mode, onMainMenu: { route = .home })
                    case .scoreboard:
                        ScoreboardView()
                    case .settings:
                        SettingsView()
                    }
                }
            }
            .environmentObject(authViewModel)
            .task {
                await authViewModel.restoreSession()
                if authViewModel.currentUserEmail != nil {
                    route = .home
                }
            }
        }
    }
}
