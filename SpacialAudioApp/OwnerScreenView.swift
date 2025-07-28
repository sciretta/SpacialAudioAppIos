//
//  OwnerScreenView.swift
//  SpacialAudioApp
//
//  Created by Leonardo on 20/7/25.
//

import SwiftUI

struct OwnerScreenView: View {
    @State private var loading: Bool = true
    @EnvironmentObject var appState: AppState

    var body: some View {
        BasicInfoLayout {
            VStack {
                if loading {
                    ProgressView()
                } else {
                    Text(
                        "Hello, World! from owner screen \n \(appState.sessionCode)"
                    )
                }
            }.onAppear {
                Task {
                    try? await Task.sleep(nanoseconds: 2_000_000_000)

                    let newCode = String(UUID().uuidString.prefix(8))
                    print(newCode)
                    appState.sessionCode = newCode
                    loading = false
                }
            }
        }

    }
}

#Preview {
    var appState = AppState()
    OwnerScreenView().environmentObject(appState).onAppear {
        appState.nickname = "Test"
    }
}
