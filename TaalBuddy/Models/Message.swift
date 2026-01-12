import Foundation

struct Message: Identifiable, Codable {
    let id: UUID
    let speaker: Speaker
    let textNL: String  // Texto en holandés
    let textES: String  // Texto en español
    let timestamp: Date
    
    enum Speaker: String, Codable {
        case user = "user"
        case assistant = "assistant"
    }
    
    init(speaker: Speaker, textNL: String, textES: String = "") {
        self.id = UUID()
        self.speaker = speaker
        self.textNL = textNL
        self.textES = textES
        self.timestamp = Date()
    }
}
