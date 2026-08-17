//
//  AuthViewModel.swift
//  Chess3D
//
//  Created by Prajjwal on 07/08/26.
//

import Foundation
import Supabase
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var state: AuthState = .signedOut
    @Published var errorMessage: String? = nil
    var currentUserEmail: String? {
        if case .signedIn(let email) = state {
            return email
        }
        return nil
    }
    func restoreSession() async {
        if let session = try? await SupabaseManager.client.auth.session {
            state = .signedIn(email: session.user.email ?? "")
        }
    }
    func signUp(email: String, password: String) async {
        errorMessage = nil
        do {
            let result = try await SupabaseManager.client.auth.signUp(email: email, password: password)
            state = .signedIn(email: result.user.email ?? email)
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    func signIn(email: String, password: String) async {
        errorMessage = nil
        do {
            let session = try await SupabaseManager.client.auth.signIn(email: email, password: password)
            state = .signedIn(email: session.user.email ?? email)
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    func signOut() async {
        try? await SupabaseManager.client.auth.signOut()
        state = .signedOut
    }
    func resetPassword(email: String) async {
        errorMessage = nil
        do {
            try await SupabaseManager.client.auth.resetPasswordForEmail(email)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
