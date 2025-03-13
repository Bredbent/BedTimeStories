//
//  APIKeyManager.swift
//  BedtimeStories
//
//  Created by Victor Uttberg on 2025-03-13.
//

// APIKeyManager.swift
import Foundation
import Security

class APIKeyManager {
    private static let service = "com.yourdomain.bedtimestories"
    private static let account = "openai_api_key"
    
    // Save API key to the keychain
    static func saveAPIKey(_ apiKey: String) -> Bool {
        guard let data = apiKey.data(using: .utf8) else { return false }
        
        // Create query dictionary
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        // Delete any existing key before saving
        SecItemDelete(query as CFDictionary)
        
        // Add the key to keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    // Retrieve API key from keychain
    static func getAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
    
    // For the prototype, we might simply use the Config value or UserDefaults
    static func getAPIKeyForPrototype() -> String {
        // Try getting from keychain first
        if let storedKey = getAPIKey(), !storedKey.isEmpty {
            return storedKey
        }
        
        // Fall back to the Config value
        return Config.openAIApiKey
    }
}
