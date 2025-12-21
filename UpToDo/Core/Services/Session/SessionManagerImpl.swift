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
        let appUser = AppUser(
            uid: user.uid,
            name: user.displayName,
            email: user.email,
            isEmailVerified: user.isEmailVerified
        )
        return appUser
    }
    
    var authState: AuthState {
        guard let user = Auth.auth().currentUser else { return .loggedOut }
        if user.isEmailVerified {
            return .verified
        }
        return .unverified
    }
    
    var isOldUser: Bool {
        UserDefaults.standard.bool(forKey: "IsOldUser")
    }
    
    func setOldUser() {
        UserDefaults.standard.set(true, forKey: "IsOldUser")
    }
    
    func reload() async throws {
        guard let user = Auth.auth().currentUser else { return }
        try await user.reload()
    }
}
