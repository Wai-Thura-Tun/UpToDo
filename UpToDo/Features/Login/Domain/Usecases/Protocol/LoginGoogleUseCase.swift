//
//  LoginWithGoogleUseCase.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 15/12/2568 BE.
//

import Foundation

protocol LoginGoogleUseCase: AnyObject {
    func execute(idToken: String?, accessToken: String) async -> Result<Void, AuthError>
}
