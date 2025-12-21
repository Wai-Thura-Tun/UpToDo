//
//  AuthRepository.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 14/12/2568 BE.
//

import Foundation

protocol AuthRepository {
    func login(email: String, password: String) async throws
    func loginWithApple(result: AppleSignInResult) async throws
    func loginWithGoogle(idToken: String, accessToken: String) async throws
    func register(email: String, password: String) async throws
    func resendVerificationEmail() async throws
    func logout() throws
    func deleteUser() async throws
}
