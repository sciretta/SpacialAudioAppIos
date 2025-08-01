//
//  SpacialAudioAppApp.swift
//  SpacialAudioApp
//
//  Created by Leonardo on 20/7/25.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var nickname: String = ""
    @Published var sessionCode: String = ""
    @Published var recordedAudioPath: String?
    @Published var status: AppStatus = .none
}

enum AppStatus {
    case recordingAudio
    case playingAudio
    case receivingAudios
    case processing
    case sendingAudio
    case none
}

@main
struct SpacialAudioApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var recorder = AudioRecorder()

    var body: some Scene {
        WindowGroup {
            RoutesView().environmentObject(appState).environmentObject(recorder)
        }
    }
}
