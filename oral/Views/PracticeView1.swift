//
//  PracticeView1.swift
//  oral
//
//  Created by Abinav Gopi on 6/7/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct PracticeView1: View {
    @State private var userName: String = ""
    @State private var animateButton = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.purple]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 30){
                Spacer()
                
                
                VStack(spacing: 10){
                    Text("Hi \(userName) 👋")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                
                ZStack{
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 160, height: 160)
                    
                    VStack(spacing:6) {
                        HStack(spacing: 20) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 25, height: 25)
                                .overlay(Circle().fill(Color.black).frame(width: 10, height: 10))
                            
                            Circle()
                                .fill(Color.white)
                                .frame(width: 25, height: 25)
                                .overlay(Circle().fill(Color.black).frame(width: 10, height: 10))
                        }
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.pink)
                            .frame(width: 40, height: 10)
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: PracticeView2()) {
                    Text("Let's Start!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 50)
                        .background(
                    LinearGradient(colors:  [Color.green, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    
                    )
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .scaleEffect(animateButton ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateButton)
                }
                Spacer()
            }
            .padding()
        }
        .onAppear {
            fetchUserName()
            animateButton = true
        }
    }
    
    private func fetchUserName() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let data = snapshot?.data(), let fetchedName = data["name"] as? String {
                self.userName = fetchedName
            }
        }
    }
}

