//
//  RegisterUseCase.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 17/12/2568 BE.
//

import Foundation

protocol RegisterUseCase: AnyObject {
    func execute(email: String?, password: String?) async -> Result<Void, AuthError>
}
