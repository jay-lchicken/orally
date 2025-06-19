//
//  OrallySignUpViw.swift
//  oral
//
//  Created by Lai Hong Yu on 6/19/25.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Foundation
import Combine
struct User: Codable, Identifiable{
    let id: String
    let name: String
    let email : String
    let joined: TimeInterval
}

class RegisterViewViewModel: ObservableObject{
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var showError = false


    init(){}
    func register(){
        guard validate() else {
            
            errorMessage = "Please check your input and make sure passwords match."
            showError = true
            return
            
        }
        
        Auth.auth().createUser(withEmail: email, password: password){ [weak self]result, error in
            
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.showError = true
                return
            }
            guard let userid = result?.user.uid else{
                return
            }
            
            self?.insertUserRecord(id: userid)
        }
    }
    func insertUserRecord(id: String){
        let newUser = User(id: id,
                           name: name,
                           email: email,
                           joined: Date().timeIntervalSince1970)
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
     func validate() -> Bool {
        print("Passsed")
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
         print("Passsed")

        guard email.contains("@") && email.contains(".") else {
            return false
        }
         print("Passsed")

        guard password.count >= 6 else {
            return false
        }
        return true
    }
   
}

struct OrallySignupView: View {
    @State var registerViewModel = RegisterViewViewModel()
    @State var name = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
            TextField("Name", text: $registerViewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)

            TextField("Email", text: $registerViewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
            

            SecureField("Password", text: $registerViewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Confirm Password", text: $registerViewModel.confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !registerViewModel.errorMessage.isEmpty {
                Text(registerViewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.horizontal)
            }

            Button(action: {
                signUp()
            }) {
                if registerViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    Text("Sign Up")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .alert(isPresented: $registerViewModel.showError) {
            Alert(title: Text("Error"), message: Text(registerViewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }

    

    private func signUp() {
        

        registerViewModel.isLoading = true
        registerViewModel.errorMessage = ""

        registerViewModel.register()
       
        
    }
    
}
