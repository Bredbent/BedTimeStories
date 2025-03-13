import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case serverError(String)
    case rateLimitExceeded
    case unauthorized
}

class AIStoryGenerator {
    private let apiKey: String
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    private let model = "gpt-3.5-turbo"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // Generate a story using async/await
    func generateStory(from request: StoryRequest) async throws -> Story {
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        // Prepare the request body
        let requestBody: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "system", "content": "You are a children's storyteller who creates magical, age-appropriate bedtime stories."],
                ["role": "user", "content": request.toPrompt()]
            ],
            "temperature": 0.7,
            "max_tokens": 800
        ]
        
        // Convert request body to JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        
        // Create URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonData
        
        // Execute request
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Check HTTP status code
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            break
        case 401:
            throw APIError.unauthorized
        case 429:
            throw APIError.rateLimitExceeded
        default:
            let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            let errorMessage = (errorResponse?["error"] as? [String: Any])?["message"] as? String ?? "Unknown error"
            throw APIError.serverError(errorMessage)
        }
        
        // Parse response
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let content = message["content"] as? String {
                
                // Extract a title from the first line or generate one
                let lines = content.components(separatedBy: "\n")
                var title = "Bedtime Story"
                var storyContent = content
                
                // Try to extract title if it's in the first line
                if let firstLine = lines.first, firstLine.contains("Title:") {
                    title = firstLine.replacingOccurrences(of: "Title:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    // Remove the title line from content
                    let contentLines = Array(lines.dropFirst())
                    storyContent = contentLines.joined(separator: "\n")
                }
                
                return Story(
                    title: title,
                    content: storyContent.trimmingCharacters(in: .whitespacesAndNewlines),
                    childName: request.childName,
                    theme: request.theme
                )
            } else {
                throw APIError.invalidResponse
            }
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
}