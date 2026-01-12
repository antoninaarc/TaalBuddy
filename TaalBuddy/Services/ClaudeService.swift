import Foundation

class ClaudeService {
    static let shared = ClaudeService()
    
    private init() {}
    
    func sendMessage(prompt: String, systemPrompt: String = "") async throws -> String {
        guard let url = URL(string: Config.claudeAPIURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(Config.claudeAPIKey, forHTTPHeaderField: "x-api-key")
        request.addValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        
        let body: [String: Any] = [
            "model": Config.claudeModel,
            "max_tokens": 1500,
            "system": systemPrompt.isEmpty ? "Je bent een vriendelijke Nederlandse taalassistent die helpt met het leren van Nederlands." : systemPrompt,
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let content = json?["content"] as? [[String: Any]]
        let text = content?.first?["text"] as? String
        
        return text ?? "Geen antwoord ontvangen"
    }
}
