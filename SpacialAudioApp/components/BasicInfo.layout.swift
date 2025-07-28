//
//  BasicInfo.container.swift
//  SpacialAudioApp
//
//  Created by Leonardo on 28/7/25.
//

import SwiftUI

struct BasicInfoLayout<Content: View>: View {
    let content: () -> Content
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 16) {
            if appState.nickname.count >= 3 {
                Text("Hola \(appState.nickname)!👋")
                    .font(.headline)
            }

            Spacer()
            content()
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
    }
}

#Preview {
    var appState = AppState()
    BasicInfoLayout {
        Text("Hello, World!")
    }.environmentObject(appState).onAppear {
        appState.nickname = "Leonardo"
    }
}
