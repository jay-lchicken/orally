//
//  SettingsView.swift
//  oral
//
//  Created by Abinav Gopi on 5/7/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SettingsView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var isDarkMode: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    // User Info
                    VStack(spacing: 8) {
                        Text("👤 \(name)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 40)

                    // Glass Cards
                    VStack(spacing: 16) {
                        SettingsCard(icon: "moon.fill", title: "Dark Mode", toggleOn: $isDarkMode)

                        Button(action: {
                            logout()
                        }) {
                            SettingsCard(icon: "rectangle.portrait.and.arrow.right", title: "Log Out")
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .onAppear {
                fetchUserDetails()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Firebase
    private func fetchUserDetails() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                name = data["name"] as? String ?? "User"
                email = data["email"] as? String ?? ""
            }
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            // You can also reset any @AppStorage or @StateObject values here if needed
        } catch {
            print("Logout failed: \(error.localizedDescription)")
        }
    }
}

struct SettingsCard: View {
    var icon: String
    var title: String
    var toggleOn: Binding<Bool>?

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.title2)
            }

            Text(title)
                .foregroundColor(.white)
                .font(.headline)

            Spacer()

            if let toggle = toggleOn {
                Toggle("", isOn: toggle)
                    .labelsHidden()
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
    }
}
