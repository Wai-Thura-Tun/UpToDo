//
//  AppleAuthManagerImpl.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 15/12/2568 BE.
//

import Foundation
import CryptoKit
import UIKit
import AuthenticationServices

@MainActor
final class AppleAuthManagerImpl: NSObject, AppleAuthManager {
    
    private var currentNonce: String?
    private var activeContinuation: CheckedContinuation<AppleSignInResult, Error>?
    private var window: UIWindow?
    
    @MainActor
    func signIn(in window: UIWindow) async throws -> AppleSignInResult {
        self.window = window
        
        let nonce = self.randomString()
        currentNonce = nonce
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.nonce = sha256(nonce)
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            self.activeContinuation = continuation
            controller.performRequests()
        }
    }

    private func randomString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._")
        var remainingLength = length
        var result: String = ""
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce.")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 { return }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let data = Data(input.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

extension AppleAuthManagerImpl: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential,
                let nonce = currentNonce,
              let fullName = credentials.fullName,
                let appleIDToken = credentials.identityToken,
                let idToken = String(data: appleIDToken, encoding: .utf8) else {
            
            activeContinuation?.resume(throwing: NSError(domain: "AppleAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Token"]))
            activeContinuation = nil
            return
        }
        
        let result = AppleSignInResult(
            idToken: idToken,
            nonce: nonce,
            fullName: fullName
        )
        
        activeContinuation?.resume(returning: result)
        activeContinuation = nil
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        
        activeContinuation?.resume(throwing: error)
        activeContinuation = nil
    }
}
