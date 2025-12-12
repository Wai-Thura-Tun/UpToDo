//
//  SessionManagerImp.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 5/12/2568 BE.
//

import Foundation
import FirebaseAuth

final class SessionManagerImpl: SessionManager {
    var currentUser: AppUser? {
        guard let user = Auth.auth().currentUser else { return nil }
        let appUser = AppUser(uid: user.uid, name: user.displayName, email: user.email)
        return appUser
    }
    
    var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    var isOldUser: Bool {
        UserDefaults.standard.bool(forKey: "IsOldUser")
    }
    
    func setOldUser() {
        UserDefaults.standard.set(true, forKey: "IsOldUser")
    }
}
