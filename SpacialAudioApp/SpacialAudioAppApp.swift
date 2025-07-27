//
//  SpacialAudioAppApp.swift
//  SpacialAudioApp
//
//  Created by Leonardo on 20/7/25.
//

import SwiftUI


class AppState: ObservableObject {
    @Published var nickname: String = ""
}

@main
struct SpacialAudioApp: App {
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            RoutesView().environmentObject(appState)
        }
    }
}

