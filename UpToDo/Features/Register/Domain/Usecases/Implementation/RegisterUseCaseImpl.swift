//
//  RegisterUseCaseImpl.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 17/12/2568 BE.
//

import Foundation

final class RegisterUseCaseImpl: RegisterUseCase {
    
    private let repository: AuthRepository!
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(email: String?, password: String?) async -> Result<Void, AuthError> {
        guard let email = email else {
            return .failure(.validationFailed(["email": "Email is required"]))
        }
        
        guard email.isEmail else {
            return .failure(.validationFailed(["email": "Your email is not valid"]))
        }
        
        guard let _ = password else {
            return .failure(.validationFailed(["password" : "Password is required"]))
        }
        
        do {
            try await self.repository.register(email: email, password: email)
            return .success(())
        }
        catch {
            return .failure(.unknown("Something went wrong"))
        }
    }
}
