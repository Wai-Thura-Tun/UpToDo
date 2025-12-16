//
//  AppleAuthManager.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 15/12/2568 BE.
//

import Foundation
import UIKit

protocol AppleAuthManager: AnyObject {
    func signIn(in window: UIWindow) async throws -> AppleSignInResult
}
