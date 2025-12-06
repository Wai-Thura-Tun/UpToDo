//
//  SessionManager.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 5/12/2568 BE.
//

import Foundation
import FirebaseAuth

protocol SessionManager {
    var currentUser: User? { get }
    var isLoggedIn: Bool { get }
}
