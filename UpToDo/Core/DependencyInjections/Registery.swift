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
        self.register(OnboardingVM.self) {
            return OnboardingVM()
        }
    }
}
