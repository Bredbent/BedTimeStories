//
//  StoryRequest.swift
//  BedtimeStories
//
//  Created by Victor Uttberg on 2025-03-13.
//

// StoryRequest.swift
import Foundation

struct StoryRequest: Codable {
    let childName: String
    let age: Int
    let theme: String
    let additionalDetails: String?
    
    // Converts object to prompt for OpenAI
    func toPrompt() -> String {
        var prompt = "Create a short, age-appropriate bedtime story for a \(age)-year-old child named \(childName)."
        prompt += " The story should be about \(theme)."
        
        if let details = additionalDetails, !details.isEmpty {
            prompt += " Include these additional details: \(details)."
        }
        
        prompt += " The story should be uplifting, educational, and end on a positive note. It should be approximately 300-500 words."
        
        return prompt
    }
}
