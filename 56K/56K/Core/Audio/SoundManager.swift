import AVFoundation
import Observation

@Observable
final class SoundManager {
    static let shared = SoundManager()

    var isSoundEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "soundEnabled") }
        set { UserDefaults.standard.set(newValue, forKey: "soundEnabled") }
    }

    private var players: [String: AVAudioPlayer] = [:]

    private init() {
        if UserDefaults.standard.object(forKey: "soundEnabled") == nil {
            UserDefaults.standard.set(false, forKey: "soundEnabled")
        }
    }

    enum Sound: String {
        case modem = "modem_handshake"
        case beep = "beep_short"
        case error = "beep_error"
        case keyPress = "key_press"
    }

    func play(_ sound: Sound) {
        guard isSoundEnabled else { return }
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "m4a") else {
            return
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            players[sound.rawValue] = player
            player.play()
        } catch {
            // Sound playback is non-critical
        }
    }

    func stop(_ sound: Sound) {
        players[sound.rawValue]?.stop()
        players.removeValue(forKey: sound.rawValue)
    }

    func stopAll() {
        players.values.forEach { $0.stop() }
        players.removeAll()
    }
}
