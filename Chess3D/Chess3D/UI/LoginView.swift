//
//  LoginView.swift
//  Chess3D
//
//  Created by Prajjwal on 08/08/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    var onSignedIn: () -> Void
    var body: some View{
        ZStack{
            Theme.background.ignoresSafeArea()
            VStack(spacing: Theme.spacing) {
                Text("Sign In").font(Theme.titleFont).foregroundStyle(.white)
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cornerRadiun))
                    .foregroundStyle(.white)
                SecureField("Password", text: $password)
                    .padding()
                    .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cornerRadiun))
                    .foregroundStyle(.white)
                if let error = authViewModel.errorMessage {
                    Text(error).foregroundStyle(.red).font(.caption)
                }
                Button("Sign In") {
                    Task {
                        await authViewModel.signIn(email: email, password: password)
                        if authViewModel.currentUserEmail != nil {
                             onSignedIn()
                        }
                          
                    }
                    
                }
                .buttonStyle(PrimaryButtonStyle())
                Button("Forgot Password?") {
                    Task { await authViewModel.resetPassword(email: email)}
                }
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
                Button("Create an account") {
                    showSignUp = true
                }.buttonStyle(SecondaryButtonStyle())
                
            }.padding(32)
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView(onSignedUp: {
                showSignUp = false
                onSignedIn()
            })
        }
    }
}
