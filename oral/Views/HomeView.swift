//
//  HomeView.swift
//  oral
//
//  Created by Lai Hong Yu on 6/19/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Hello, ")
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .padding()
            HStack {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 145, height: 145)
                    .cornerRadius(10)
                    .padding()
                    
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 145, height: 145)
                    .cornerRadius(10)
                    .padding()
            }
            
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 335, height: 400)
                    .cornerRadius(10)
                    .padding()
            Button(action: {
                //Action type of stuff u wanna add becoz i forgot  how to add nav link or somthing
            }) {
                Text("Click to start your practice")
            }
                    
                
            }
            Spacer()
        
    }
}
#Preview {
    HomeView()
}
