//
//  ContentView.swift
//  oral
//
//  Created by Lai Hong Yu on 6/19/25.
//

import SwiftUI
import FirebaseAuth
import Combine
class MainViewViewModel:ObservableObject{
    @Published var currentUserId:String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    init(){
        self.handler = Auth.auth().addStateDidChangeListener { [weak self]_, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
            }
            self?.currentUserId = user?.uid ?? ""}
        print("MainViewViewModel initialized with user ID: \(self.currentUserId)")
        print("Is user signed in? \(self.isSignedIn)")
    }
    public var isSignedIn:Bool{
        return Auth.auth().currentUser != nil
    }
}

struct ContentView: View {
    @StateObject var viewModel = MainViewViewModel()
    var body: some View{
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty{
                accountView        } else {
            OrallyAuthView()
        }
    }
    @ViewBuilder
    var accountView: some View{
        TabView{
            
        }
    }
}

#Preview {
    ContentView()
}
