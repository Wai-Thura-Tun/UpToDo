//
//  LogoutUseCaseImpl.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 19/12/2568 BE.
//

import Foundation

final class LogoutUseCaseImpl: LogoutUseCase {
    
    private let repository: AuthRepository!
    
    init(repository: AuthRepository!) {
        self.repository = repository
    }
    
    func execute() -> Result<Void, AuthError> {
        do {
            try self.repository.logout()
            return .success(())
        }
        catch {
            return .failure(.unknown("Unable to logout right now"))
        }
    }
}
