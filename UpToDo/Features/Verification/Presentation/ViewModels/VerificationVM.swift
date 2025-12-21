//
//  VerificationVM.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 18/12/2568 BE.
//

import Foundation

protocol VerificationViewDelegate: AnyObject {
    func didFinishVerification()
    func onFailed(message: String)
    func onResendVerificationSuccess(title: String, message: String)
    func onCancelVerification()
}

@MainActor
final class VerificationVM {
    private let sessionManager: SessionManager!
    
    private var tasks: Task<Void, Error>?
    
    private var isLoading: Bool = false
    
    private weak var delegate: VerificationViewDelegate?
    
    private let resendVerificationUseCase: ResendVerificationUseCase!
    private let deleteUserUseCase: DeleteUserUseCase!
    
    init(
        sessionManager: SessionManager,
        resendVerificationUseCase: ResendVerificationUseCase,
        deleteUserUseCase: DeleteUserUseCase
    )
    {
        self.sessionManager = sessionManager
        self.resendVerificationUseCase = resendVerificationUseCase
        self.deleteUserUseCase = deleteUserUseCase
    }
    
    func setDelegate(_ delegate: VerificationViewDelegate) {
        self.delegate = delegate
    }
    
    func checkVerification() {
        tasks = Task { [weak self] in
            guard let self = self else { return }
            
            do {
                try await self.sessionManager.reload()
                
                guard !Task.isCancelled else { return }
                
                if let user = self.sessionManager.currentUser, user.isEmailVerified {
                    self.delegate?.didFinishVerification()
                }
                else {
                    self.delegate?.onFailed(message: "Something went wrong! Check your mail and try again")
                }
            }
            catch {
                self.delegate?.onFailed(message: "Verification Failed")
            }
        }
    }
    
    func resendVerification() {
        guard !self.isLoading else { return }
        self.isLoading = true
        
        tasks = Task { [weak self] in
            defer {
                self?.isLoading = false
                self?.tasks = nil
            }
            
            guard let self = self else { return }
            let result = await self.resendVerificationUseCase.execute()
            
            switch result {
            case .success(_):
                self.delegate?.onResendVerificationSuccess(
                    title: "Verification Email",
                    message: "We've sent a new verification email with a link to continue."
                )
            case .failure(let failure):
                switch failure {
                case .unknown(let errorMessage):
                    self.delegate?.onFailed(message: errorMessage)
                default:
                    self.delegate?.onFailed(message: "Something went wrong")
                }
            }
        }
    }
    
    func deleteUser() {
        guard !self.isLoading else { return }
        self.isLoading = true
        
        tasks = Task { [weak self] in
            defer {
                self?.isLoading = false
                self?.tasks = nil
            }
            
            guard let self = self else { return }
            
            let result = await deleteUserUseCase.execute()
            
            switch result {
            case .success(_):
                self.delegate?.onCancelVerification()
            case .failure(let failure):
                switch failure {
                case .unknown(let errorMessage):
                    self.delegate?.onFailed(message: errorMessage)
                default:
                    self.delegate?.onFailed(message: "Something went wrong")
                }
            }
        }
    }
    
    deinit {
        self.tasks?.cancel()
        self.tasks = nil
    }
}
