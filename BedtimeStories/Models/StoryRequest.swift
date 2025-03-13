// StoryRequest.swift
import Foundation

struct StoryRequest: Codable {
    let childName: String
    let age: Int
    let theme: String
    let additionalDetails: String?
    
    // Converts object to prompt for OpenAI
    func toPrompt() -> String {
        var prompt = "Skapa en kort, åldersanpassad godnattsaga för ett \(age)-årigt barn som heter \(childName)."
        prompt += " Sagan ska handla om \(theme)."
        
        if let details = additionalDetails, !details.isEmpty {
            prompt += " Inkludera dessa detaljer: \(details)."
        }
        
        prompt += " Sagan ska vara upplyftande, lärorik och sluta på ett positivt sätt. Den ska vara ungefär 300-500 ord lång. Skriv alltid på svenska."
        
        return prompt
    }
}
