//
//  RecordButton.component.swift
//  SpacialAudioApp
//
//  Created by Leonardo on 30/7/25.
//

import SwiftUI

struct RecorderButton: View {
    @EnvironmentObject var recorder: AudioRecorder
    @EnvironmentObject var appState: AppState
    
    var onStop: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 20) {
            Button(recorder.isRecording ? "Detener" : "Grabar") {
                if recorder.isRecording {
                    recorder.stopRecording()
                    appState.status = .none
                    onStop?()
                } else {
                    let filePath = recorder.startRecording()

                    appState.status = .recordingAudio

                    appState.recordedAudioPath = filePath
                }
            }
            .padding()
            .background(recorder.isRecording ? Color.red : Color.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }
}

#Preview {
    return RecorderButton(onStop: {
        print("🎤 Grabación terminada, ejecutar acción")
        // Por ejemplo: enviar el audio, navegar, cambiar estado, etc.
    })
        .environmentObject(AppState()).environmentObject(AudioRecorder())
}
