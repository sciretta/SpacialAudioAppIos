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

    func startNewSession() async {
        guard let url = URL(string: "\(API_URL)create-session") else {
            print("URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let json = try? JSONSerialization.jsonObject(with: data)
                as? [String: Any],
                let code = json["session_code"] as? String
            {
                print("session code", code)
                DispatchQueue.main.async {
                    appState.sessionCode = code
                    //                    appState.status = .owner
                    //                    path.append(.owner)
                }
            } else {
                print("Respuesta inesperada")
            }
        } catch {
            print("Error al crear sesión:", error)
        }

        loading = false
    }

    func setFinished() async {
        let sessionCode = appState.sessionCode
        guard let url = URL(string: "\(API_URL)/set-finished") else {
            print("❌ URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("text/plain", forHTTPHeaderField: "Accept")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.setValue(sessionCode, forHTTPHeaderField: "sessioncode")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                print("✅ set-finished status: \(httpResponse.statusCode)")
            }
        } catch {
            print("❌ Error al llamar set-finished:", error)
        }
    }

    func saveSession() {
        print("saving session")
    }

    var body: some View {
        BasicInfoLayout {
            VStack {
                if loading {
                    ProgressView()
                } else {
                    Text("SESSION CODE: \(appState.sessionCode)")
                    GuestsListView()
                    Spacer()
                    if appState.status == .none
                        && appState.recordedAudioPath != nil
                    {
                        PlayButton()
                        Button("Save session") {
                            saveSession()
                        }
                    } else {
                        RecorderButton(onStop: {
                            Task { await setFinished() }

                        })
                    }
                    Spacer()
                }
            }
        }.onAppear {
            Task {
                await startNewSession()
            }
            appState.recordedAudioPath = nil
        }

    }
}

#Preview {
    var appState = AppState()
    OwnerScreenView().environmentObject(appState).environmentObject(
        AudioRecorder()
    ).onAppear {
        appState.nickname = "Test"
    }
}
