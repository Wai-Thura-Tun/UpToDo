//
//  LoginVM.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 13/12/2568 BE.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

protocol LoginViewDelegate: AnyObject {
    func onValidate(valiationErrors: [LoginVM.ValidationError])
    func onLoginSuccess()
    func onFailed(message: String?, validationErrors: [String: String]?)
}

@MainActor
final class LoginVM {
    
    enum ValidationError {
        case EmailTextField(String)
        case PasswordTextField(String)
    }
    
    private var email:String?
    private var password: String?
    
    private weak var delegate: LoginViewDelegate?
    
    private let googleAuthManager: GoogleAuthManager!
    private let appleAuthManager: AppleAuthManager!
    
    private let loginUseCase: LoginUseCase!
    private let loginGoogleUseCase: LoginGoogleUseCase!
    private let loginAppleUseCase: LoginAppleUseCase!
    
    private var tasks: Task<Void, Error>?
    private(set) var isLoading: Bool = false
    
    init(
        appleAuthManager: AppleAuthManager,
        googleAuthManager: GoogleAuthManager,
        loginUseCase: LoginUseCase,
        loginAppleUseCase: LoginAppleUseCase,
        loginGoogleUseCase: LoginGoogleUseCase
    )
    {
        self.appleAuthManager = appleAuthManager
        self.googleAuthManager = googleAuthManager
        self.loginUseCase = loginUseCase
        self.loginAppleUseCase = loginAppleUseCase
        self.loginGoogleUseCase = loginGoogleUseCase
    }
    
    func setDelegate(_ delegate: LoginViewDelegate) {
        self.delegate = delegate
    }
    
    func setEmail(_ email: String?) {
        self.email = email
    }
    
    func setPassword(_ password: String?) {
        self.password = password
    }
    
    func login() {
        guard !self.isLoading else { return }
        self.isLoading = true
        
        tasks = Task { [weak self] in
            defer {
                self?.isLoading = false
                self?.tasks = nil
            }
            
            guard let self = self else { return }
            
            let result = await self.loginUseCase.execute(email: self.email, password: self.password)
            
            guard !Task.isCancelled else { return }
            
            switch result {
            case .success(_):
                self.delegate?.onLoginSuccess()
            case .failure(let error):
                switch error {
                case .validationFailed(let validationErrors):
                    self.delegate?.onFailed(message: nil, validationErrors: validationErrors)
                case .unknown(let errorMessage):
                    self.delegate?.onFailed(message: errorMessage, validationErrors: nil)
                }
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
    
    func validateForm() {
        var validationErrors: [ValidationError] = []
        if email == nil || email == "" {
            validationErrors.append(.EmailTextField("Email is required."))
        }
        
        if password == nil || password == "" {
            validationErrors.append(.PasswordTextField("Password is required."))
        }
        self.delegate?.onValidate(valiationErrors: validationErrors)
    }
    
    deinit {
        tasks?.cancel()
        tasks = nil
    }
}
