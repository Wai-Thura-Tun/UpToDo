//
//  AuthCoordinator.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 8/12/2568 BE.
//

import Foundation
import UIKit

enum AuthEntryState {
    case login
    case verification
}

@MainActor
final class AuthCoordinator: Coordinator {
    
    weak var parent: AppCoordinator?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    private let authEntryState: AuthEntryState
    
    init(navigationController: UINavigationController, state: AuthEntryState) {
        self.navigationController = navigationController
        self.authEntryState = state
    }
    
    func start() {
        self.navigationController.viewControllers = []
        
        switch self.authEntryState {
        case .login:
            self.showLogin()
        case .verification:
            self.showVerification(asRoot: true)
        }
    }
    
    // MARK: - Login
    
    func showLogin(asRoot: Bool = false) {
        let loginVC: LoginVC = .instantiate()
        let vm: LoginVM = Resolver.shared.resolve(LoginVM.self)
        loginVC.configure(with: vm, coordinator: self)
        
        UIView.transition(with: self.navigationController.view, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            self?.navigationController.setViewControllers([loginVC], animated: false)
        }
    }
    
    func didFinishLogin() {
        self.parent?.didFinishAuthFlow(self)
    }
    
    // MARK: - Register
    
    func showRegister() {
        let registerVC: RegisterVC = .instantiate()
        let vm: RegisterVM = Resolver.shared.resolve(RegisterVM.self)
        registerVC.configure(with: vm, coordinator: self)
        self.navigationController.pushViewController(registerVC, animated: true)
    }
    
    func didCancelRegister() {
        self.navigationController.popViewController(animated: true)
    }
    
    func didFinishRegister() {
        self.showVerification()
    }
    
    // MARK: - Verification
    
    func showVerification(asRoot: Bool = false) {
        let verificationVC: VerificationVC = .instantiate()
        let vm: VerificationVM = Resolver.shared.resolve(VerificationVM.self)
        verificationVC.configure(with: vm, coordinator: self)
        
        if asRoot {
            self.navigationController.setViewControllers([verificationVC], animated: false)
        }
        else {
            let nav = UINavigationController(rootViewController: verificationVC)
            self.navigationController.modalPresentationStyle = .pageSheet
            self.navigationController.present(nav, animated: true)
        }
    }
    
    func didFinishVerification() {
        self.navigationController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            if let _ = self.navigationController.viewControllers.last as? RegisterVC {
                return
            }
            self.parent?.didFinishAuthFlow(self)
        }
    }
}
