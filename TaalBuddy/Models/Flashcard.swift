import Foundation

struct Flashcard: Identifiable, Codable {
    let id: UUID
    let dutch: String
    let spanish: String
    let category: String
    let example: String?  // Ejemplo de uso
    
    init(dutch: String, spanish: String, category: String, example: String? = nil) {
        self.id = UUID()
        self.dutch = dutch
        self.spanish = spanish
        self.category = category
        self.example = example
    }
}
