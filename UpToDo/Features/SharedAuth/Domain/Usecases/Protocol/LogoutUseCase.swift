//
//  LogoutUseCase.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 19/12/2568 BE.
//

import Foundation

protocol LogoutUseCase: AnyObject {
    func execute() -> Result<Void, AuthError>
}
