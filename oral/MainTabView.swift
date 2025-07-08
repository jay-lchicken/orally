//
//  MainTabView.swift
//  oral
//
//  Created by Abinav Gopi on 7/7/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            NotesView()
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Notes")
                }
            RewardsView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Rewards")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .accentColor(.purple)
    }
}
