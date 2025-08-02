//
//  PlayButton.component.swift
//  SpacialAudioApp
//
//  Created by Leonardo on 1/8/25.
//

import SwiftUI

public struct PlayButton: View {
    @EnvironmentObject var recorder: AudioRecorder
    @EnvironmentObject var appState: AppState

    public var body: some View {
        VStack(spacing: 16) {

            VStack {
                ProgressView(
                    value: recorder.currentTime,
                    total: recorder.duration
                )
                .progressViewStyle(LinearProgressViewStyle())

                HStack {
                    Text(formatTime(recorder.currentTime))
                        .font(.caption)
                    Spacer()
                    Text(formatTime(recorder.duration))
                        .font(.caption)
                }

                ZStack {
                    Spacer()
                    Button(
                        recorder.isPlaying
                            ? "Reproduciendo..." : "Reproducir"
                    ) {
                        recorder.playRecording()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .disabled(recorder.isPlaying).frame(
                        maxWidth: .infinity,
                        alignment: .center
                    )

                    HStack {
                        Spacer().frame(width: 200)
                        Button(action: {
                            appState.recordedAudioPath = nil
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .imageScale(.large)
                        }
                    }

                }.padding(.horizontal)

            }
            .padding(.horizontal)
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    PlayButton().environmentObject(AudioRecorder()).environmentObject(AppState())
}
