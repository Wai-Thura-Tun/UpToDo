//
//  GoogleAuthManager.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 16/12/2568 BE.
//

import Foundation
import UIKit

protocol GoogleAuthManager: AnyObject {
    func signIn(in window: UIWindow) async throws -> (String?, String?)
}
