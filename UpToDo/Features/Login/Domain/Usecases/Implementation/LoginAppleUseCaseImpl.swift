//
//  LoginAppleUseCase.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 16/12/2568 BE.
//

import Foundation

final class LoginAppleUseCaseImpl: LoginAppleUseCase {
    private let repository: AuthRepository!
    
    init(repository: AuthRepository!) {
        self.repository = repository
    }
    
    func execute(result: AppleSignInResult) async -> Result<Void, AuthError> {
        do {
            try await repository.loginWithApple(result: result)
            return .success(())
        }
        catch {
            return .failure(.unknown("Something went wrong"))
        }
    }
}
    
