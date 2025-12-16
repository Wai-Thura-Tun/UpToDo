//
//  AuthError.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 14/12/2568 BE.
//

import Foundation

enum AuthError: Error {
    case validationFailed([String: String])
    case unknown(String)
}
