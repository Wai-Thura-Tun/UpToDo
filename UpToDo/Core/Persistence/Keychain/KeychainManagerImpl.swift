//
//  KeychainManagerImpl.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 14/12/2568 BE.
//

import Foundation
import KeychainAccess

final class KeychainManagerImpl: KeychainManager {
    
    private let keychain: Keychain = .init(service: "UpToDo")
    
    func get(key: KeychainKeys) -> String? {
        return self.keychain[key.rawValue]
    }
    
    func set(key: KeychainKeys, value: String) {
        self.keychain[key.rawValue] = value
    }
    
    func delete(key: KeychainKeys) {
        self.keychain[key.rawValue] = nil
    }
    
    func deleteAll() {
        try? self.keychain.removeAll()
    }
    
}
