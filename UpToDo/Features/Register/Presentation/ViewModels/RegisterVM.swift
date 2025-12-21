//
//  RegisterVM.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 16/12/2568 BE.
//

import Foundation
import UIKit

protocol RegisterViewDelegate: AnyObject {
    func onValidate(validationErrors: [RegisterVM.ValidationError])
    func onRegisterSuccess()
    func onLoginSuccess()
    func onFailed(message: String?, validationErrors: [String: String]?)
}

@MainActor
final class RegisterVM {
    
    enum ValidationError {
        case EmailTextField(String)
        case PasswordTextField(String)
        case ConfirmPasswordTextField(String)
    }
    
    private weak var delegate: RegisterViewDelegate?
    
    private var email: String?
    private var password: String?
    private var confirmPassword: String?
    
    private let appleAuthManager: AppleAuthManager!
    private let googleAuthManager: GoogleAuthManager!
    private let loginAppleUseCase: LoginAppleUseCase!
    private let loginGoogleUseCase: LoginGoogleUseCase!
    private let registerUseCase: RegisterUseCase!
    
    private(set) var isLoading: Bool = false
    private var tasks: Task<Void, Error>?
    
    init(
        appleAuthManager: AppleAuthManager,
        googleAuthManager: GoogleAuthManager,
        loginAppleUseCase: LoginAppleUseCase,
        loginGoogleUseCase: LoginGoogleUseCase,
        registerUseCase: RegisterUseCase
    )
    {
        self.appleAuthManager = appleAuthManager
        self.googleAuthManager = googleAuthManager
        self.loginAppleUseCase = loginAppleUseCase
        self.loginGoogleUseCase = loginGoogleUseCase
        self.registerUseCase = registerUseCase
    }
    
    func setDelegate(_ delegate: RegisterViewDelegate) {
        self.delegate = delegate
    }
    
    func setEmail(_ email: String?) {
        self.email = email
    }
    
    func setPassword(_ password: String?) {
        self.password = password
    }
    
    func setConfirmPassword(_ confirmPassword: String?) {
        self.confirmPassword = confirmPassword
    }
    
    func loginWithApple(in window: UIWindow?) {
        guard let window = window else { return }
        guard !self.isLoading else { return }
        self.isLoading = true
        
        tasks = Task { [weak self] in
            defer {
                self?.isLoading = false
                self?.tasks = nil
            }
            guard let self = self else { return }
            
            do {
                let appleResult = try await self.appleAuthManager.signIn(in: window)
                
                let response = await self.loginAppleUseCase.execute(result: appleResult)
                
                guard !Task.isCancelled else { return }
                
                switch response {
                case .success(_):
                    self.delegate?.onLoginSuccess()
                case .failure(_):
                    self.delegate?.onFailed(message: "Something went wrong", validationErrors: nil)
                }
            }
            catch {
                self.delegate?.onFailed(message: "Something went wrong", validationErrors: nil)
            }
        }
    }
    
    func loginWithGoogle(in window: UIWindow?) {
        guard let window = window else { return }
        guard !self.isLoading else { return }
        self.isLoading = true
        
        tasks = Task { [weak self] in
            
            defer {
                self?.isLoading = false
                self?.tasks = nil
            }
            
            guard let self = self else { return }
            do {
                let (idToken, accessToken) = try await self.googleAuthManager.signIn(in: window)
                
                guard let idToken = idToken, let accessToken = accessToken else { return }
                
                let result = await self.loginGoogleUseCase.execute(idToken: idToken, accessToken: accessToken)
                
                guard !Task.isCancelled else { return }
                
                switch result {
                case .success(_):
                    self.delegate?.onLoginSuccess()
                case .failure(let error):
                    switch error {
                        case .unknown(let errorMessage):
                            self.delegate?.onFailed(message: errorMessage, validationErrors: nil)
                        default:
                            self.delegate?.onFailed(message: "Something went wrong", validationErrors: nil)
                    }
                }
            }
            catch {
                let error = error as NSError
                switch error.code {
                case -5:
                    self.delegate?.onFailed(message: "You just cancelled the Google Sign In", validationErrors: nil)
                default:
                    self.delegate?.onFailed(message: "Something went wrong", validationErrors: nil)
                }
            }
        }
    }
    
    func register() {
        guard !self.isLoading else { return }
        self.isLoading = true
        
        tasks = Task { [weak self] in
            
            defer {
                self?.isLoading = false
                self?.tasks = nil
            }
            
            guard let self = self else { return }
            
            let result = await self.registerUseCase.execute(email: self.email, password: self.password)
            
            switch result {
            case .success(_):
                self.delegate?.onRegisterSuccess()
            case .failure(_):
                self.delegate?.onFailed(message: "Something went wrong", validationErrors: nil)
            }
        }
    }
    
    func validateForm() {
        var validationErrors: [ValidationError] = []
        
        if self.email == nil || self.email == "" {
            validationErrors.append(.EmailTextField("Email is required"))
        }
        
        if self.password == nil || self.password == "" {
            validationErrors.append(.PasswordTextField("Password is required"))
        }
        
        if self.confirmPassword == nil || self.confirmPassword == "" {
            validationErrors.append(.ConfirmPasswordTextField("Confirm Password is required"))
        }
        
        if let confirmPassword = self.confirmPassword, !confirmPassword.isEmpty, let password = self.password, !password.isEmpty, confirmPassword != password {
            validationErrors.append(.ConfirmPasswordTextField("Passwords should be match"))
        }
        
        self.delegate?.onValidate(validationErrors: validationErrors)
    }
    
    deinit {
        self.tasks?.cancel()
        self.tasks = nil
    }
}
