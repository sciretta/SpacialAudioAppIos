//
//  GuestsList.component.swift
//  SpacialAudioApp
//
//  Created by Leonardo on 1/8/25.
//

import SwiftUI

struct GuestsListView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
           VStack(alignment: .leading, spacing: 16) {
               Text("GUESTS")
                   .font(.caption)
                   .foregroundColor(.secondary)
                   .padding(.horizontal)

               ScrollView {
                   VStack(spacing: 8) {
                       ForEach(appState.guests, id: \.self) { guest in
                           ListItem(title: guest)
                       }
                   }
                   .padding(.horizontal)
               }
           }
           .padding(.top)
       }
}

struct ListItem: View {
    var title: String

    var body: some View {
        Text(title)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
    }
}

#Preview {
    GuestsListView()
        .environmentObject(AppState()) // Usa los valores por defecto
}
