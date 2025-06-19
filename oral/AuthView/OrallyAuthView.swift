//
//  OrallyAuthView.swift
//  oral
//
//  Created by Lai Hong Yu on 6/19/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct OrallyAuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isSignedIn = false
    
    var body: some View {
        NavigationView{
            ZStack{
                LinearGradient(
                    gradient: Gradient(colors: [Color .purple, Color .blue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 28){
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("Welcome to Orally")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Mastyer your oral exams")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                    NavigationLink(destination: OrallyLoginView()) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .glassEffect()
                            .padding()
                    }
                    NavigationLink(destination: OrallySignupView()) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .glassEffect()
                    }
                    Spacer()
                    
                    
                }
    
            }
        }
    }
}

struct OrallyLoginView: View{
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var isAuthenticated: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .disabled(isLoading)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .disabled(isLoading)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.horizontal)
            }
            
            Button(action: {
                signIn()
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                } else {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .disabled(isLoading || !isValidInput())
            .padding(.horizontal)
            
            Button(action: {
                
            }) {
                Text("Forgot Password?")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
            .padding(.top, 5)
            
            Spacer()
        }
        .padding()
        .alert("Authentication Error", isPresented: $showError) {
            Button("OK", role: .cancel) {
                showError = false
            }
        } message: {
            Text(errorMessage)
        }
        
    }
    
    private func isValidInput() -> Bool {
        return !email.isEmpty && password.count >= 6
    }
    
    private func signIn() {
        isLoading = true
        errorMessage = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            isLoading = false
            
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
                return
            }
            isAuthenticated = true
            print("User signed in: \(authResult?.user.uid ?? "unknown")")
        }
    }
}
