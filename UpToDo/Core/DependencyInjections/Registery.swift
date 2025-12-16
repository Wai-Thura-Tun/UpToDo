//
//  Register.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 5/12/2568 BE.
//

import Foundation

extension Resolver {
    func registerDependencies() {
        // MARK: - Register dependencies here
        
        // MARK: - Singletons
        
        self.register(SessionManager.self, lifecyle: .singleton) {
            return SessionManagerImpl()
        }
        
        // MARK: - Transients
        
        // Services
        self.register(AppleAuthManager.self) {
            return AppleAuthManagerImpl()
        }
        
        self.register(GoogleAuthManager.self) {
            return GoogleAuthManagerImpl()
        }
        
        self.register(OnboardingVM.self) {
            let sessionManager: SessionManager = Resolver.shared.resolve(SessionManager.self)
            return OnboardingVM(sessionManager: sessionManager)
        }
        
        self.register(AuthRepository.self) {
            return AuthRepositoryImpl()
        }
        
        self.register(LoginUseCase.self) {
            let repository: AuthRepository = Resolver.shared.resolve(AuthRepository.self)
            return LoginUseCaseImpl(repository: repository)
        }
        
        self.register(LoginGoogleUseCase.self) {
            let repository: AuthRepository = Resolver.shared.resolve(AuthRepository.self)
            return LoginGoogleUseCaseImpl(repository: repository)
        }
        
        self.register(LoginAppleUseCase.self) {
            let repository: AuthRepository = Resolver.shared.resolve(AuthRepository.self)
            return LoginAppleUseCaseImpl(repository: repository)
        }
        
        self.register(LoginVM.self) {
            let loginUseCase: LoginUseCase = Resolver.shared.resolve(LoginUseCase.self)
            let loginGoogleUseCase: LoginGoogleUseCase = Resolver.shared.resolve(LoginGoogleUseCase.self)
            let loginAppleUseCase: LoginAppleUseCase = Resolver.shared.resolve(LoginAppleUseCase.self)
            
            let appleAuthManager: AppleAuthManager = Resolver.shared.resolve(AppleAuthManager.self)
            let googleAuthManager: GoogleAuthManager = Resolver.shared.resolve(GoogleAuthManager.self)
            
            return LoginVM(
                appleAuthManager: appleAuthManager,
                googleAuthManager: googleAuthManager,
                loginUseCase: loginUseCase,
                loginAppleUseCase: loginAppleUseCase,
                loginGoogleUseCase: loginGoogleUseCase
            )
        }
    }
}
