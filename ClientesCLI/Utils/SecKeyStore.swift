//
//  SecKeyStore.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 23/7/22.
//

import Foundation
import Security

@propertyWrapper
struct KeyChain {
    let key:String
    
    var wrappedValue:Data? {
        get {
            SecKeyStore.shared.readKey(label: key)
        }
        set {
            if let value = newValue {
                SecKeyStore.shared.storeKey(key: value, label: key)
            } else {
                SecKeyStore.shared.deleteKey(label: key)
            }
        }
    }
}

final class SecKeyStore {
    static let shared = SecKeyStore()
    
    func storeKey(key:Data, label:String, type:CFString = kSecClassGenericPassword) {
        let query = [
            kSecClass: type,
            kSecAttrAccount: label,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
            kSecUseDataProtectionKeychain: true,
            kSecValueData: key
        ] as [String:Any]
        
        if readKey(label: label, type: type) == nil {
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                print("Error grabando \(label): Status \(status)")
            }
        } else {
            let attributes = [
                kSecAttrAccount: label,
                kSecValueData: key
            ] as [String:Any]
            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            if status != errSecSuccess {
                print("Error actualizando \(label): Status \(status)")
            }
        }
    }
    
    func readKey(label:String, type:CFString = kSecClassGenericPassword) -> Data? {
        let query = [
            kSecClass: type,
            kSecAttrAccount: label,
            kSecUseDataProtectionKeychain: true,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as [String:Any]
        
        var item:AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status != errSecSuccess {
            return nil
        } else {
            return item as? Data
        }
    }
    
    func deleteKey(label:String, type:CFString = kSecClassGenericPassword) {
        let query = [
            kSecClass: type,
            kSecAttrAccount: label
        ] as [String:Any]
        let result = SecItemDelete(query as CFDictionary)
        if result == noErr {
            print("Item \(label) borrado.")
        }
    }
}
