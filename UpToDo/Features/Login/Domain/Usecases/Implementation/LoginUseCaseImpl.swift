//
//  LoginUseCaseImpl.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 14/12/2568 BE.
//

import Foundation

final class LoginUseCaseImpl: LoginUseCase {
    
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(email: String?, password: String?) async -> Result<Void, AuthError> {
        guard let email = email else {
            return .failure(.validationFailed(["email": "Email is required"]))
        }
        
        guard email.isEmail else {
            return .failure(.validationFailed(["email": "Email is not valid"]))
        }
        
        guard let password = password else {
            return .failure(.validationFailed(["password": "Password is required"]))
        }
        
        do {
            try await repository.login(email: email, password: password)
            return .success(())
        }
        catch {
            return .failure(.unknown("Login Failed"))
        }
    }
}
