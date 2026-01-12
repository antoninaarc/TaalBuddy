import SwiftUI

struct SituatiesListView: View {
    @State private var situations: [Situation] = []
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            if situations.isEmpty && !isLoading {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Situaties laden...")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            } else {
                List(situations) { situation in
                    NavigationLink(destination: SituationDetailView(situation: situation)) {
                        HStack(spacing: 15) {
                            Text(situation.emoji)
                                .font(.system(size: 40))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(situation.title)
                                    .font(.headline)
                                
                                Text(getSituationSubtitle(for: situation.title))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Situaties")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if situations.isEmpty {
                await loadSituations()
            }
        }
    }
    
    private func getSituationSubtitle(for title: String) -> String {
        switch title {
        case "In het café": return "Koffie bestellen"
        case "In de winkel": return "Boodschappen doen"
        case "Openbaar vervoer": return "Kaartje kopen"
        case "Bij de dokter": return "Afspraak maken"
        case "Op kantoor": return "Praten met collega's"
        default: return "Oefenen"
        }
    }
    
    private func loadSituations() async {
        isLoading = true
        
        let situationPrompts = [
            (title: "In het café", emoji: "☕️", context: "ordering coffee at a café"),
            (title: "In de winkel", emoji: "🏪", context: "shopping at a convenience store"),
            (title: "Openbaar vervoer", emoji: "🚌", context: "buying a ticket for public transport"),
            (title: "Bij de dokter", emoji: "🏥", context: "making an appointment at the doctor"),
            (title: "Op kantoor", emoji: "💼", context: "talking with colleagues at the office")
        ]
        
        var loadedSituations: [Situation] = []
        
        for prompt in situationPrompts {
            do {
                let systemPrompt = """
                Je bent een Nederlandse taalleraar. Genereer een natuurlijk dialoog in het Nederlands voor de situatie: "\(prompt.context)".
                
                Formaat (EXACT):
                Speaker1: [Nederlandse zin]
                [Spaanse vertaling]
                
                Speaker2: [Nederlandse zin]
                [Spaanse vertaling]
                
                Regels:
                - 4-6 uitwisselingen
                - Natuurlijk Nederlands (A2-B1 niveau)
                - Gebruik relevante speaker namen (bijv. Barista, Klant)
                - Elke zin moet op een aparte regel
                - Spaanse vertaling direct onder elke Nederlandse zin
                """
                
                let userPrompt = "Genereer een dialoog voor: \(prompt.context)"
                
                let response = try await ClaudeService.shared.sendMessage(
                    prompt: userPrompt,
                    systemPrompt: systemPrompt
                )
                
                let dialogues = parseDialogue(from: response)
                
                let situation = Situation(
                    title: prompt.title,
                    emoji: prompt.emoji,
                    dialogues: dialogues
                )
                
                loadedSituations.append(situation)
                
            } catch {
                print("Error loading situation: \(error)")
            }
        }
        
        situations = loadedSituations
        isLoading = false
    }
    
    private func parseDialogue(from text: String) -> [DialogueLine] {
        var dialogues: [DialogueLine] = []
        let lines = text.components(separatedBy: "\n").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        var i = 0
        while i < lines.count {
            let line = lines[i].trimmingCharacters(in: .whitespaces)
            
            if line.contains(":") {
                let parts = line.split(separator: ":", maxSplits: 1)
                if parts.count == 2 {
                    let speaker = String(parts[0]).trimmingCharacters(in: .whitespaces)
                    let textNL = String(parts[1]).trimmingCharacters(in: .whitespaces)
                    
                    var textES = ""
                    if i + 1 < lines.count {
                        let nextLine = lines[i + 1].trimmingCharacters(in: .whitespaces)
                        if !nextLine.contains(":") {
                            textES = nextLine
                            i += 1
                        }
                    }
                    
                    let dialogue = DialogueLine(speaker: speaker, textNL: textNL, textES: textES)
                    dialogues.append(dialogue)
                }
            }
            i += 1
        }
        
        return dialogues
    }
}
