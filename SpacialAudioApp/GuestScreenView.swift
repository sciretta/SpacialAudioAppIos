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
                if appState.sessionCode.isEmpty {
                    EnterSessionCode()
                } else {
                    Text("SESSION CODE: \(appState.sessionCode)")
                    if appState.status == .none
                        && appState.recordedAudioPath != nil
                    {
                        PlayButton()
                    } else {
                        RecorderButton()
                    }
                }
            }
            .onAppear {
                appState.sessionCode = ""
            }
        }
    }
}

#Preview {
    var appState = AppState()
    GuestScreenView().environmentObject(appState).environmentObject(
        AudioRecorder()
    ).onAppear {
        appState.nickname = "Test"
    }
}
