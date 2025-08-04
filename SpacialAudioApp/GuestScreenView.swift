//
//  OwnerScreenView.swift
//  SpacialAudioApp
//
//  Created by Leonardo on 20/7/25.
//

import SwiftUI

struct GuestScreenView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var recorder: AudioRecorder

    func sendAudio() async {
        guard let url = URL(string: "\(API_URL)add-buffer") else {
            print("URL inválida")
            return
        }

        guard let path = appState.recordedAudioPath else {
            print("⚠️ No hay ruta de audio grabado")
            return
        }

        let fileURL = URL(fileURLWithPath: path)

        do {
            let fileData = try Data(contentsOf: fileURL)

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(
                "application/octet-stream",
                forHTTPHeaderField: "Content-Type"
            )
            request.setValue(
                "application/octet-stream",
                forHTTPHeaderField: "Accept"
            )
            request.setValue(
                appState.sessionCode,
                forHTTPHeaderField: "sessioncode"
            )
            request.httpBody = fileData

            let (data, response) = try await URLSession.shared.data(
                for: request
            )

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta no válida")
                return
            }

            if httpResponse.statusCode == 200 {
                print(
                    "Archivo enviado correctamente, res: \(String(describing: String(data: data, encoding: .utf8)))"
                )
            } else {
                print("Error en la solicitud: \(httpResponse.statusCode)")
            }
        } catch {
            print("Error al enviar el archivo:", error)
        }
    }

    func startSubscribeSession() {
        print("📡 startSubscribeSession")

        let sessionCode = appState.sessionCode

        guard let url = URL(string: "\(API_URL)subscribe-guest") else {
            print("❌ URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(sessionCode, forHTTPHeaderField: "sessioncode")

        let task = URLSession.shared.dataTask(with: request) {
            data,
            response,
            error in
            if let error = error {
                print("❌ Error en conexión SSE:", error)
                return
            }

            guard let inputStream = data else {
                print("❌ No hay datos")
                return
            }

            // Convertimos el stream en líneas (eventos del SSE)
            if let text = String(data: inputStream, encoding: .utf8) {
                print("📨 Evento SSE recibido:")
                text.enumerateLines { line, _ in
                    print("→ \(line)")

                    if line.contains("session_finished") {
                        DispatchQueue.main.async {
                            let path = recorder.stopRecording()
                            appState.recordedAudioPath = path
                            appState.status = .none
                        }
                    }
                }
            }
        }

        task.resume()

    }

    var body: some View {
        BasicInfoLayout {
            VStack {
                if appState.sessionCode.isEmpty {
                    EnterSessionCode()
                } else {
                    Group {
                        Text("SESSION CODE: \(appState.sessionCode)")
                        if appState.status == .none
                            && appState.recordedAudioPath != nil
                        {
                            PlayButton()
                            Button("Send audio") {
                                Task { await sendAudio() }
                            }
                        } else {
                            RecorderButton().onAppear {
                                startSubscribeSession()

                            }
                        }
                    }
                }
            }
            .onAppear {
                appState.sessionCode = ""
                appState.recordedAudioPath = nil
            }
        }
    }
}

#Preview {
    var appState = AppState()
    GuestScreenView().environmentObject(appState).environmentObject(
        AudioRecorder()
    ).environmentObject(AudioRecorder()).onAppear {
        appState.nickname = "Test"
    }
}
