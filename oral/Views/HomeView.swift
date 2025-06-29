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
    @State private var level: Int = 3
    @State private var streak: Int = 7 // Is it madde sure that the number of days in the streak is counted by making sure user is doing a practice everyday and that determines the fire symbols? Any other way to determine fire symbol
    
    var boy: some View{
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 25){
                    HStack {
                        VStack(alignment: .leading){
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
                    
                    HStack(spacing: 30) {
                        VStack{
                            Image(systemName: "flame.fill")
                                .font(.system(size: 38))
                                .foregroundColor(.orange)
                            Text("\(streak)-day streak")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        ZStack{
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 10)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(min(xp / 500, 1)))
                                .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .animation(.easeOut, value: xp)
                            VStack(spacing: 2){
                                Text("\(Int(xp)) XP")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                            .frame(width: 80, height: 80)
                        }
                        VStack(spacing: 16) {
                            NavigationLink(destination: PracticeView1()) {
                                HomeGlassCard(icon: "mic.fill", title: "Start Practice", "Improve your oral skills to ace the test")
                            }
                            
                            NavigationLink(destination: HistoryView()) {
                                HomeGlassCard(icon: "clock.fill", title: "Review History", "See your progress over time")
                            }
                            HomeGlassCard(icon: "sparkles", title: "Tip of the day",subtitle: "Get a smart oral tip") // Continue from here on. Erase when starting
                        }
                    }
                }
            }
        }
    }
}

