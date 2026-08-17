//
//  SignUpView.swift
//  Chess3D
//
//  Created by Prajjwal on 08/08/26.
//

import SwiftUI
struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    var onSignedUp: () -> Void
    
    var body: some View {
        VStack(spacing: Theme.spacing) {
            Text("Create Account").font(Theme.headingFont)
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cornerRadiun))
            SecureField("Password (min 5 characters)", text: $password)
                .padding()
                .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cornerRadiun))
            if let error = authViewModel.errorMessage {
                Text(error).foregroundStyle(.red).font(.caption)
            }
            Button("Sign Up") {
                        Task {
                            await authViewModel.signUp(email: email, password: password)
                            if authViewModel.currentUserEmail != nil { onSignedUp() }
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(32)
        }
    }

