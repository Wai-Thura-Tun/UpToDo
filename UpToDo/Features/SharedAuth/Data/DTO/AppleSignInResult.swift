//
//  AppleSignInResult.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 16/12/2568 BE.
//

import Foundation

struct AppleSignInResult {
    let idToken: String
    let nonce: String
    let fullName: PersonNameComponents
}
