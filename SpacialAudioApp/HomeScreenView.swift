//
//  HomeScreenView.swift
//  SpacialAudioApp
//
//  Created by Leonardo on 21/7/25.
//

import SwiftUI

struct HomeScreenView: View {
    @Binding var path: [Screens]
    @EnvironmentObject var appState: AppState

    var body: some View {
        BasicInfoLayout {
            VStack {
                TextField("Nickname", text: $appState.nickname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                NavigationLink(destination: OwnerScreenView()) {
                    Text("Start session")
                        .disabled(appState.nickname.count < 3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            appState.nickname.count >= 3
                                ? Color.blue : Color.gray
                        )
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                NavigationLink(destination: GuestScreenView()) {
                    Text("Join session")
                        .frame(maxWidth: .infinity)  // Hacemos que el texto ocupe todo el ancho
                        .padding()
                        .foregroundColor(
                            appState.nickname.count >= 3
                                ? Color.blue : Color.gray
                        )
                        .background(Color.white)  // Opcional, para mejorar contraste
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    appState.nickname.count >= 3
                                        ? Color.blue : Color.gray,
                                    lineWidth: 2
                                )
                        )
                }
                .disabled(appState.nickname.count < 3)
            }
        }
    }
}

#Preview {
    HomeScreenView(path: .constant([])).environmentObject(AppState())
}
