//
//  ResendVerificationUseCase.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 19/12/2568 BE.
//

import Foundation

protocol ResendVerificationUseCase {
    func execute() async -> Result<Void, AuthError>
}
