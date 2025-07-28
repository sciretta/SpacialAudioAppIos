//
//  OwnerScreenView.swift
//  SpacialAudioApp
//
//  Created by Leonardo on 20/7/25.
//

import SwiftUI

struct GuestScreenView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        BasicInfoLayout {
            VStack {
                !appState.sessionCode.isEmpty
                    ? AnyView(Text("SESSION CODE: \(appState.sessionCode)"))
                    : AnyView(EnterSessionCode())
            }
            .onAppear {
                appState.sessionCode = ""
            }
        }
    }
}

#Preview {
    var appState = AppState()
    GuestScreenView().environmentObject(appState).onAppear {
        appState.nickname = "Test"
    }
}
