import AVFoundation
import Foundation

class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private var recordingSession: AVAudioSession!
    private var timer: Timer?

    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 1 

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
            isPlaying = false
            print("Grabando en: \(audioURL)")

            return audioURL.path
        } catch {
            print("Error al comenzar grabación: \(error)")
            return nil
        }
    }

    func stopRecording()-> String?  {
        recorder?.stop()
        recorder = nil
        isRecording = false
        return audioURL.path
    }

    func playRecording() {
        do {
            try recordingSession.setCategory(.playback, mode: .default)
            try recordingSession.setActive(true)

            player = try AVAudioPlayer(contentsOf: audioURL)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()

            isPlaying = true
            duration = player?.duration ?? 1
            startProgressTimer()

            print("🎧 Reproduciendo audio")
        } catch {
            print("Error al reproducir: \(error)")
        }
    }

    private func startProgressTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.player else { return }
            self.currentTime = player.currentTime

            if !player.isPlaying {
                self.timer?.invalidate()
                self.isPlaying = false
            }
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        timer?.invalidate()
        currentTime = 0
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
