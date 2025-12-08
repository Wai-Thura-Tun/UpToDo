//
//  UseDefaultsManager.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 8/12/2568 BE.
//

import Foundation

extension UserDefaults {
    
    var isOldUser: Bool {
        return UserDefaults.standard.bool(forKey: "IsOldUser")
    }
    
    func setOldUser() {
        UserDefaults.standard.set(true, forKey: "IsOldUser")
    }
}
