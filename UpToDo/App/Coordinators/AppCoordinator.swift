//
//  AppCoordinator.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 5/12/2568 BE.
//

import Foundation
import UIKit

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
    
    private func checkSession() {
        if sessionManager.isLoggedIn {
            showMainFlow()
        }
        else {
            if sessionManager.isOldUser {
                showAuthFlow()
            }
            else {
                showOnboardingFlow()
            }
        }
    }
    
    private func showSplash() {
        if ProcessInfo.processInfo.arguments.contains("UITestSkipSplash") {
            didFinishSplash()
            return
        }
        
        let splashVC: SplashVC = .instantiate()
        splashVC.coordinator = self
        self.navigationController.pushViewController(splashVC, animated: true)
    }
    
    private func showOnboardingFlow() {
        if ProcessInfo.processInfo.arguments.contains("UITestSkipOnboarding") {
            didFinishOnboarding()
            return
        }
        
        let onboardingVC: OnboardingVC = .instantiate()
        let vm: OnboardingVM = Resolver.shared.resolve(OnboardingVM.self)
        onboardingVC.configure(with: vm, coordinator: self)
        
        UIView.transition(with: self.navigationController.view, duration: 0.3, options: .transitionCrossDissolve) {
            self.navigationController.setViewControllers([onboardingVC], animated: false)
        }
    }
    
    private func showAuthFlow() {
        let authCoordinator: AuthCoordinator = .init(navigationController: self.navigationController)
        self.childCoordinators.append(authCoordinator)
        authCoordinator.parent = self
        authCoordinator.start()
    }
    
    private func showMainFlow() {
        let homeCoordinator: HomeCoordinator = .init(navigationController: self.navigationController)
        self.childCoordinators.append(homeCoordinator)
        homeCoordinator.parent = self
        homeCoordinator.start()
    }
    
    func didFinishOnboarding() {
        self.navigationController.viewControllers = []
        showAuthFlow()
    }
    
    func didFinishAuthFlow(_ coordinator: Coordinator) {
        removeChildCoordinators(coordinator)
        self.navigationController.viewControllers = []
        showMainFlow()
    }
    
    func didFinishSplash() {
        self.navigationController.viewControllers = []
        checkSession()
    }
    
    private func removeChildCoordinators(_ coordinator: Coordinator) {
        self.childCoordinators.remove(at: self.childCoordinators.firstIndex { $0 === coordinator } ?? 0)
    }
    
    deinit {
        self.childCoordinators = []
    }
}
