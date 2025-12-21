//
//  DeleteUserUseCaseImpl.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 20/12/2568 BE.
//

import Foundation

final class DeleteUserUseCaseImpl: DeleteUserUseCase {
    
    private let repository: AuthRepository!
    
    init(repository: AuthRepository!) {
        self.repository = repository
    }
    
    func execute() async -> Result<Void, AuthError> {
        do {
            try await repository.deleteUser()
            return .success(())
        }
        catch {
            return .failure(.unknown("Something went wrong"))
        }
    }
}
