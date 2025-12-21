//
//  SessionManager.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 5/12/2568 BE.
//

import Foundation
import FirebaseAuth

enum AuthState {
    case loggedOut
    case unverified
    case verified
}

protocol SessionManager {
    var currentUser: AppUser? { get }
    var authState: AuthState { get }
    var isOldUser: Bool { get }
    func setOldUser()
    func reload() async throws
}

