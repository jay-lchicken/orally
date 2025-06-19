//
//  oralApp.swift
//  oral
//
//  Created by Lai Hong Yu on 6/19/25.
//

import SwiftUI
import FirebaseCore

@main
struct oralApp: App {
    init() {
        FirebaseApp.configure()

    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
