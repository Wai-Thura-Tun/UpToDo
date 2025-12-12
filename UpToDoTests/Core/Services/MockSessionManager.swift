//
//  MockSessionManager.swift
//  UpToDoTests
//
//  Created by Wai Thura Tun on 10/12/2568 BE.
//

import Foundation
@testable import UpToDo

final class MockSessionManager: SessionManager {
    
    var didCallSetOldUser: Bool = false
    
    var currentUser: AppUser?
    var isLoggedIn: Bool = false
    var isOldUser: Bool = false
    
    func setOldUser() {
        didCallSetOldUser = false
        isOldUser = true
    }
}
