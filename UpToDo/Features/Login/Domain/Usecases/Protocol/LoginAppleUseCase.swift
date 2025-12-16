//
//  LoginAppleUseCase.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 16/12/2568 BE.
//

import Foundation

protocol LoginAppleUseCase: AnyObject {
    func execute(result: AppleSignInResult) async -> Result<Void, AuthError>
}
