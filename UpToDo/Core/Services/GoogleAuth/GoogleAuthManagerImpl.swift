//
//  GoogleAuthManagerImpl.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 16/12/2568 BE.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseCore

@MainActor
final class GoogleAuthManagerImpl: GoogleAuthManager {
    
    func signIn(in window: UIWindow) async throws -> (String?, String?) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return (nil, nil)
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let vc = window.rootViewController else { return (nil, nil) }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: vc)
        
        let idToken: String? = result.user.idToken?.tokenString
        let accessToken: String = result.user.accessToken.tokenString
        
        return (idToken, accessToken)
    }
}
