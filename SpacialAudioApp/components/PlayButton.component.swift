//
//  PlayButton.component.swift
//  SpacialAudioApp
//
//  Created by Leonardo on 1/8/25.
//

import SwiftUI

public struct PlayButton: View {

    @EnvironmentObject var recorder: AudioRecorder
    public var body: some View {
        Button("Reproducir") {
            recorder.playRecording()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Capsule())
    }
}

#Preview {
    PlayButton().environmentObject(AudioRecorder())
}
