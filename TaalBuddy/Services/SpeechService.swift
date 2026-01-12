import AVFoundation
import SwiftUI

class SpeechService: ObservableObject {
    static let shared = SpeechService()
    
    private let synthesizer = AVSpeechSynthesizer()
    @Published var isSpeaking = false
    @Published var currentSpeakingId: UUID?
    
    private init() {
        synthesizer.delegate = SynthesizerDelegate.shared
        SynthesizerDelegate.shared.speechService = self
    }
    
    func speak(text: String, language: String = "nl-NL", id: UUID? = nil) {
        // Si ya está hablando, detener primero
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.45 // Velocidad normal (0.0 - 1.0)
        utterance.pitchMultiplier = 1.0
        
        currentSpeakingId = id
        isSpeaking = true
        
        synthesizer.speak(utterance)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        currentSpeakingId = nil
    }
}

// Delegate para manejar eventos del synthesizer
class SynthesizerDelegate: NSObject, AVSpeechSynthesizerDelegate {
    static let shared = SynthesizerDelegate()
    weak var speechService: SpeechService?
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.speechService?.isSpeaking = false
            self.speechService?.currentSpeakingId = nil
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.speechService?.isSpeaking = false
            self.speechService?.currentSpeakingId = nil
        }
    }
}
