import AVFoundation
import Foundation

class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private var recordingSession: AVAudioSession!

    @Published var isRecording = false

    private var audioURL: URL {
        getDocumentsDirectory().appendingPathComponent("recording.m4a")
    }

    override init() {
        super.init()
        recordingSession = AVAudioSession.sharedInstance()
        requestPermission()
    }

    private func requestPermission() {
        recordingSession.requestRecordPermission { allowed in
            DispatchQueue.main.async {
                if !allowed {
                    print("Permiso denegado para grabar")
                }
            }
        }
    }

    func startRecording() -> String? {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
        ]

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)

            recorder = try AVAudioRecorder(url: audioURL, settings: settings)
            recorder?.delegate = self
            recorder?.record()

            isRecording = true
            print("Grabando en: \(audioURL)")

            return audioURL.path
        } catch {
            print("Error al comenzar grabación: \(error)")
            return nil
        }
    }

    func stopRecording() {
        recorder?.stop()
        recorder = nil
        isRecording = false
    }

    func playRecording() {
        do {
            try recordingSession.setCategory(.playback, mode: .default)
            try recordingSession.setActive(true)

            player = try AVAudioPlayer(contentsOf: audioURL)
            player?.prepareToPlay()
            player?.play()
            print("🎧 Reproduciendo audio")
        } catch {
            print("Error al reproducir: \(error)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[
            0
        ]
    }
}
