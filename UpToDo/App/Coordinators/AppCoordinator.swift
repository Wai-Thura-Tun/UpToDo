//
//  AppCoordinator.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 5/12/2568 BE.
//

import Foundation
import UIKit

@MainActor
final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    private let sessionManager: SessionManager
    
    init(
        navigationController: UINavigationController,
        sessionManager: SessionManager
    ) {
        self.navigationController = navigationController
        self.sessionManager = sessionManager
    }
    
    func start() {
        showSplash()
    }
    
    // MARK: Routing
    
    func route() {
        self.navigationController.viewControllers = []
        
        Task { [weak self] in
            try? await self?.sessionManager.reload()
        }
        
        if !sessionManager.isOldUser {
            self.startOnboardingFlow()
            return
        }
        
        switch sessionManager.authState {
        case .loggedOut:
            self.startAuthFlow(entry: .login)
        case .unverified:
            self.startAuthFlow(entry: .verification)
        case .verified:
            self.startMainFlow()
        }
    }
    
    
    // MARK: - Splash
    private func showSplash() {
        if ProcessInfo.processInfo.arguments.contains("UITestSkipSplash") {
            self.didFinishSplash()
            return
        }
        
        let splashVC: SplashVC = .instantiate()
        splashVC.configure(coordinator: self)
        self.navigationController.setViewControllers([splashVC], animated: true)
    }
    
    func didFinishSplash() {
        self.route()
    }
    
    // MARK: - Onboarding
    
    private func startOnboardingFlow() {
        if ProcessInfo.processInfo.arguments.contains("UITestSkipOnboarding") {
            self.didFinishOnboarding()
            return
        }
        
        let onboardingVC: OnboardingVC = .instantiate()
        let vm: OnboardingVM = Resolver.shared.resolve(OnboardingVM.self)
        onboardingVC.configure(with: vm, coordinator: self)
        
        UIView.transition(with: self.navigationController.view, duration: 0.3, options: .transitionCrossDissolve) {
            self.navigationController.setViewControllers([onboardingVC], animated: false)
        }
    }
    
    func didFinishOnboarding() {
        self.navigationController.viewControllers = []
        self.startAuthFlow(entry: .login)
    }
    
    // MARK: - Auth
    
    private func startAuthFlow(entry: AuthEntryState) {
        let authCoordinator: AuthCoordinator = .init(
            navigationController: self.navigationController,
            state: entry
        )
        authCoordinator.parent = self
        self.childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    func didFinishAuthFlow(_ coordinator: Coordinator) {
        removeChildCoordinators(coordinator)
        self.route()
    }
    
    // MARK: - Home
    
    private func startMainFlow() {
        let homeCoordinator: HomeCoordinator = .init(
            navigationController: self.navigationController
        )
        homeCoordinator.parent = self
        self.childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
    
    
    private func removeChildCoordinators(_ coordinator: Coordinator) {
        self.childCoordinators.removeAll { $0 === coordinator }
    }
}
