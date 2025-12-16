//
//  KeychainManager.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 14/12/2568 BE.
//

import Foundation

protocol KeychainManager {
    func get(key: KeychainKeys) -> String?
    func set(key: KeychainKeys, value: String)
    func delete(key: KeychainKeys)
    func deleteAll()
}
