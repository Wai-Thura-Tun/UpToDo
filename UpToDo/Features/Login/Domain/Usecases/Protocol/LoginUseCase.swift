//
//  LoginUseCase.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 14/12/2568 BE.
//

import Foundation

protocol LoginUseCase {
    func execute(email: String?, password: String?) async -> Result<Void, AuthError>
}
