import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("TaalBuddy")
                            .font(.system(size: 36, weight: .bold))
                        Text("Leer Nederlands op een leuke manier")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    // Features Grid
                    VStack(spacing: 16) {
                        // Situaties
                        NavigationLink(destination: SituatiesListView()) {
                            FeatureCard(
                                emoji: "📚",
                                title: "Situaties",
                                description: "Leer praktische gesprekken",
                                color: .blue
                            )
                        }
                        
                        // Flashcards
                        NavigationLink(destination: Text("Woordenschat - Coming soon")) {
                            FeatureCard(
                                emoji: "🎴",
                                title: "Woordenschat",
                                description: "Oefen met flashcards",
                                color: .green
                            )
                        }
                        
                        // DE vs HET
                        NavigationLink(destination: Text("DE vs HET - Coming soon")) {
                            FeatureCard(
                                emoji: "⚖️",
                                title: "DE vs HET",
                                description: "Leer de regels",
                                color: .orange
                            )
                        }
                        
                        // Verbos Separables
                        NavigationLink(destination: Text("Verbos - Coming soon")) {
                            FeatureCard(
                                emoji: "🔄",
                                title: "Scheidbare werkwoorden",
                                description: "Meester verbos separables",
                                color: .purple
                            )
                        }
                        
                        // Chatbot
                        NavigationLink(destination: Text("Chat - Coming soon")) {
                            FeatureCard(
                                emoji: "💬",
                                title: "Oefen Chat",
                                description: "Praat in het Nederlands",
                                color: .pink
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Feature Card Component
struct FeatureCard: View {
    let emoji: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Emoji
            Text(emoji)
                .font(.system(size: 50))
                .frame(width: 70, height: 70)
                .background(color.opacity(0.2))
                .cornerRadius(15)
            
            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Arrow
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
