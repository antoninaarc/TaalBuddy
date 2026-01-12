import Foundation

struct Situation: Identifiable, Codable {
    let id: UUID
    let title: String
    let emoji: String
    let dialogues: [DialogueLine]
    
    init(title: String, emoji: String, dialogues: [DialogueLine]) {
        self.id = UUID()
        self.title = title
        self.emoji = emoji
        self.dialogues = dialogues
    }
}

struct DialogueLine: Identifiable, Codable {
    let id: UUID
    let speaker: String  // "Barista", "Jij", etc.
    let textNL: String
    let textES: String
    
    init(speaker: String, textNL: String, textES: String) {
        self.id = UUID()
        self.speaker = speaker
        self.textNL = textNL
        self.textES = textES
    }
}
