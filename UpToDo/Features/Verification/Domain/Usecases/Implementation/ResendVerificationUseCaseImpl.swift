//
//  ResendVerificationUseCaseImpl.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 19/12/2568 BE.
//

import Foundation

final class ResendVerificationUseCaseImpl: ResendVerificationUseCase {
    private let repository: AuthRepository!
    
    init(repository: AuthRepository!) {
        self.repository = repository
    }
    
    func execute() async -> Result<Void, AuthError> {
        do {
            try await self.repository.resendVerificationEmail()
            return .success(())
        }
        catch {
            return .failure(.unknown("Unable to send verification email"))
        }
    }
}
