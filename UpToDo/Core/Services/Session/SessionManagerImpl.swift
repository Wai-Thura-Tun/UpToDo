//
//  SessionManagerImp.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 5/12/2568 BE.
//

import Foundation
import FirebaseAuth

final class SessionManagerImpl: SessionManager {
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    var isLoggedIn: Bool {
        return currentUser != nil
    }
}
