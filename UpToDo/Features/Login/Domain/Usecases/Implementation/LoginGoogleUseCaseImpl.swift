//
//  LoginWithGoogleUseCaseImpl.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 15/12/2568 BE.
//

import Foundation

final class LoginGoogleUseCaseImpl: LoginGoogleUseCase {
    
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(idToken: String?, accessToken: String) async -> Result<Void, AuthError> {
        
        guard let idToken = idToken else {
            return .failure(.unknown("Authentication Failed!"))
        }
        
        do {
            try await self.repository.loginWithGoogle(
                idToken: idToken,
                accessToken: accessToken
            )
            return .success(())
        }
        catch {
            return .failure(.unknown("Something went wrong"))
        }
    }
}
