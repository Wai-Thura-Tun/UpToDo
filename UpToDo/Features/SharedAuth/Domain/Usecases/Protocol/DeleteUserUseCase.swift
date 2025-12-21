//
//  DeleteUserUseCase.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 20/12/2568 BE.
//

import Foundation

protocol DeleteUserUseCase: AnyObject {
    func execute() async -> Result<Void, AuthError>
}
