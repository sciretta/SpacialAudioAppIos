//
//  HomeScreenView.swift
//  SpacialAudioApp
//
//  Created by Leonardo on 21/7/25.
//

import SwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack {
            TextField("Nickname", text: $appState.nickname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
            
            Button("START NEW SESSION (owner)") {
                print("start:\(appState.nickname)")
            }
            .disabled(appState.nickname.count < 3)
            .padding()
            .frame(maxWidth: .infinity)
            .background(appState.nickname.count >= 3 ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)

            
            NavigationLink(destination: GuestScreenView()) {
                        Text("Join session")
            }
            .disabled(appState.nickname.count < 3)
            .padding()
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(appState.nickname.count >= 3 ? Color.blue : Color.gray, lineWidth: 2)
            )
            .foregroundColor(appState.nickname.count >= 3 ? Color.blue : Color.gray)
        }
    }
}

#Preview {
    HomeScreenView().environmentObject(AppState())
}
