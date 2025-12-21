//
//  AuthRepositoryImpl.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 14/12/2568 BE.
//

import Foundation
import FirebaseAuth

final class AuthRepositoryImpl: AuthRepository {
    
    private let auth: Auth
    
    init() {
        self.auth = Auth.auth()
    }
    
    func login(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func loginWithApple(result: AppleSignInResult) async throws {
        let credential = OAuthProvider.appleCredential(
            withIDToken: result.idToken,
            rawNonce: result.nonce,
            fullName: result.fullName
        )
        
        try await auth.signIn(with: credential)
    }
    
    func loginWithGoogle(idToken: String, accessToken: String) async throws {
        let credentials: AuthCredential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: accessToken
        )
        
        try await auth.signIn(with: credentials)
    }
    
    func register(email: String, password: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        try await result.user.sendEmailVerification()
    }
    
    func resendVerificationEmail() async throws {
        try await auth.currentUser?.sendEmailVerification()
    }
    
    func logout() throws {
        try auth.signOut()
    }
    
    func deleteUser() async throws {
        try await auth.currentUser?.delete()
    }
}
