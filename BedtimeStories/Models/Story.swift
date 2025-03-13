// Story.swift
import Foundation

struct Story: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let childName: String
    let theme: String
    let createdAt: Date = Date()
    
    // For storing favorites in UserDefaults
    func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "title": title,
            "content": content,
            "childName": childName,
            "theme": theme,
            "createdAt": createdAt.timeIntervalSince1970
        ]
    }
    
    // For retrieving from UserDefaults
    static func fromDictionary(_ dict: [String: Any]) -> Story? {
        guard
            let title = dict["title"] as? String,
            let content = dict["content"] as? String,
            let childName = dict["childName"] as? String,
            let theme = dict["theme"] as? String
        else {
            return nil
        }
        
        return Story(title: title, content: content, childName: childName, theme: theme)
    }
}
