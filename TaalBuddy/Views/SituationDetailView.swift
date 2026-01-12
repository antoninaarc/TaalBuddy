import SwiftUI

struct SituationDetailView: View {
    let situation: Situation
    @StateObject private var speechService = SpeechService.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text(situation.emoji)
                        .font(.system(size: 80))
                    
                    Text(situation.title)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 30)
                
                // Diálogos
                VStack(spacing: 20) {
                    ForEach(situation.dialogues) { dialogue in
                        DialogueCardView(
                            dialogue: dialogue,
                            isPlaying: speechService.currentSpeakingId == dialogue.id
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if speechService.isSpeaking {
                    Button(action: {
                        speechService.stop()
                    }) {
                        Image(systemName: "stop.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

struct DialogueCardView: View {
    let dialogue: DialogueLine
    let isPlaying: Bool
    @StateObject private var speechService = SpeechService.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(dialogue.speaker)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            
            HStack(alignment: .top, spacing: 12) {
                Text(dialogue.textNL)
                    .font(.title3)
                    .fontWeight(.medium)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                Button(action: {
                    if isPlaying {
                        speechService.stop()
                    } else {
                        speechService.speak(
                            text: dialogue.textNL,
                            language: "nl-NL",
                            id: dialogue.id
                        )
                    }
                }) {
                    Image(systemName: isPlaying ? "stop.circle.fill" : "speaker.wave.2.fill")
                        .font(.title2)
                        .foregroundColor(isPlaying ? .red : .blue)
                        .scaleEffect(isPlaying ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: isPlaying)
                }
                .buttonStyle(.plain)
            }
            
            Text(dialogue.textES)
                .font(.callout)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
