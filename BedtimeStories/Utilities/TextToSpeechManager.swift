import Foundation
import AVFoundation

class TextToSpeechManager: NSObject, ObservableObject {
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    @Published var isSpeaking: Bool = false
    
    override init() {
        super.init()
        speechSynthesizer.delegate = self
    }
    
    func speak(_ text: String, voice: String = "com.apple.ttsbundle.Alva-compact") {
        // Stop any ongoing speech
        if isSpeaking {
            stopSpeaking()
        }
        
        // Create utterance
        let utterance = AVSpeechUtterance(string: text)
        
        // Configure voice - use Swedish voice
        if let voice = AVSpeechSynthesisVoice(identifier: voice) {
            utterance.voice = voice
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "sv-SE")
        }
        
        // Configure speech parameters
        utterance.rate = 0.5  // Slow down for bedtime stories
        utterance.pitchMultiplier = 1.0
        utterance.volume = 0.8
        
        // Start speaking
        speechSynthesizer.speak(utterance)
        isSpeaking = true
    }
    
    func stopSpeaking() {
        speechSynthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension TextToSpeechManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}
