//
//  KeychainManager.swift
//  Weather
//
//  Created by Дмитрий К on 11.05.2025.
//

import Foundation
import Security

struct KeychainManager: KeychainManagerProtocol {
    
    func save(key: String, data: Data) -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String      : kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String  : data
        ]

        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    func load(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String      : kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String : kCFBooleanTrue!,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess else { return nil }
        return dataTypeRef as? Data
    }
    
    func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
    
    func save(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        return save(key: key, data: data) == errSecSuccess
    }

    func loadString(key: String) -> String? {
        guard let data = load(key: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }

}

protocol KeychainManagerProtocol {
    func save(key: String, data: Data) -> OSStatus
    func load(key: String) -> Data?
    func delete(key: String)
    func save(key: String, value: String) -> Bool
    func loadString(key: String) -> String?
}
