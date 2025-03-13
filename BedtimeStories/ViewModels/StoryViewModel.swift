import Foundation
import SwiftUI
import Combine

enum StoryGenerationState {
    case idle
    case generating
    case success(Story)
    case failure(Error)
}

class StoryViewModel: ObservableObject {
    // Input fields
    @Published var childName: String = ""
    @Published var age: String = ""
    @Published var theme: String = ""
    @Published var additionalDetails: String = ""
    
    // Generation state
    @Published var generationState: StoryGenerationState = .idle
    @Published var recentStories: [Story] = []
    
    // API Service
    private let storyGenerator: AIStoryGenerator
    
    // Form validation
    @Published var isFormValid: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.storyGenerator = AIStoryGenerator(apiKey: APIKeyManager.getAPIKeyForPrototype())
        
        // Form validation using Combine
        Publishers.CombineLatest3($childName, $age, $theme)
            .map { name, age, theme in
                return !name.isEmpty && !age.isEmpty && !theme.isEmpty && Int(age) != nil
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
        
        // Load recent stories from UserDefaults
        loadRecentStories()
    }
    
    // Generate a story
    func generateStory() async {
        guard isFormValid, let ageInt = Int(age) else { return }
        
        DispatchQueue.main.async {
            self.generationState = .generating
        }
        
        do {
            let request = StoryRequest(
                childName: childName,
                age: ageInt,
                theme: theme,
                additionalDetails: additionalDetails.isEmpty ? nil : additionalDetails
            )
            
            let story = try await storyGenerator.generateStory(from: request)
            
            DispatchQueue.main.async {
                self.generationState = .success(story)
                self.addToRecentStories(story)
            }
        } catch {
            DispatchQueue.main.async {
                self.generationState = .failure(error)
            }
        }
    }
    
    // Save story to recents
    private func addToRecentStories(_ story: Story) {
        // Add to in-memory array
        recentStories.insert(story, at: 0)
        
        // Limit to 10 recent stories
        if recentStories.count > 10 {
            recentStories = Array(recentStories.prefix(10))
        }
        
        // Save to UserDefaults
        saveRecentStories()
    }
    
    // Save recent stories to UserDefaults
    private func saveRecentStories() {
        let storiesDict = recentStories.map { $0.toDictionary() }
        UserDefaults.standard.set(storiesDict, forKey: "recentStories")
    }
    
    // Load recent stories from UserDefaults
    private func loadRecentStories() {
        guard let storiesDict = UserDefaults.standard.array(forKey: "recentStories") as? [[String: Any]] else {
            return
        }
        
        let stories = storiesDict.compactMap { Story.fromDictionary($0) }
        self.recentStories = stories
    }
    
    // Reset form fields
    func resetForm() {
        childName = ""
        age = ""
        theme = ""
        additionalDetails = ""
        generationState = .idle
    }
    
    // Helper to get error message
    func errorMessage(for error: Error) -> String {
        if let apiError = error as? APIError {
            switch apiError {
            case .unauthorized:
                return "Ogiltig API-nyckel. Vänligen kontrollera dina inställningar."
            case .rateLimitExceeded:
                return "Hastighetsgräns överskriden. Vänligen försök igen senare."
            case .serverError(let message):
                return "Serverfel: \(message)"
            default:
                return "Ett fel inträffade: \(apiError.localizedDescription)"
            }
        }
        return "Ett oväntat fel inträffade: \(error.localizedDescription)"
    }
}
