//
//  HomeView.swift
//  oral
//
//  Created by Lai Hong Yu on 6/19/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeView: View {
    @State private var name: String = ""
    @State private var xp: Double = 280
    @State private var streak: Int = 7 // Is it madde sure that the number of days in the streak is counted by making sure user is doing a practice everyday and that determines the fire symbols? Any other way to determine fire symbol
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 25) {
                    // Greeting
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Welcome back,")
                                .foregroundColor(.white.opacity(0.8))
                                .font(.subheadline)
                            Text("\(name) 👋")
                                .foregroundColor(.white)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                        }
                        Spacer()
                    }
                    .padding(.horizontal)

                    // XP & Streak Row
                    HStack(spacing: 30) {
                        VStack {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 38))
                                .foregroundColor(.orange)
                            Text("\(streak)-day streak")
                                .font(.caption)
                                .foregroundColor(.white)
                        }

                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 10)

                            Circle()
                                .trim(from: 0, to: CGFloat(min(xp / 500, 1)))
                                .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .animation(.easeOut, value: xp)

                            VStack(spacing: 2) {
                                Text("\(Int(xp)) XP")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                        }
                        .frame(width: 80, height: 80)
                    }

                    // Glass Cards
                    VStack(spacing: 16) {
                        NavigationLink(destination: PracticeView1()) {
                            HomeGlassCard(icon: "mic.fill", title: "Start Practice", subtitle: "Improve your oral skills to ace the test")
                        }

//                        NavigationLink(destination: HistoryView()) {
//                            HomeGlassCard(icon: "clock.fill", title: "Review History", subtitle: "See your progress over time")
//                        }

                        HomeGlassCard(icon: "sparkles", title: "Tip of the Day", subtitle: "Get a smart oral tip")
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top, 60)
            }
            .onAppear {
                fetchUserName()
            }
        }
    }

    private func fetchUserName() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let data = snapshot?.data(), let userName = data["name"] as? String {
                self.name = userName
            }
        }
    }

    // 👇 HomeGlassCard is now nested right here
    struct HomeGlassCard: View {
        var icon: String
        var title: String
        var subtitle: String

        var body: some View {
            HStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.title2)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .foregroundColor(.white)
                        .font(.headline)
                    Text(subtitle)
                        .foregroundColor(.white.opacity(0.7))
                        .font(.caption)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(18)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        }
    }
}
