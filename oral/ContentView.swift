//
//  ContentView.swift
//  oral
//
//  Created by Lai Hong Yu on 6/19/25.
//

import SwiftUI
import FirebaseAuth

class MainViewViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    private var handler: AuthStateDidChangeListenerHandle?

    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
            }
        }
    }

    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}

struct ContentView: View {
    @StateObject var viewModel = MainViewViewModel()

    var body: some View {
        Group {
            if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
                MainTabView()
            } else {
                OrallyAuthView()
            }
        }
    }
}
