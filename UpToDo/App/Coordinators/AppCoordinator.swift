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
    
    var childCoordinators: [any Coordinator] = []
    
    private let sessionManager: SessionManager
    
    init(
        navigationController: UINavigationController,
        sessionManager: SessionManager
    ) {
        self.navigationController = navigationController
        self.sessionManager = sessionManager
    }
    
    func start() {
        
        // Splash First
        
        let splashVC: SplashVC = .instantiate()
        splashVC.coordinator = self
        self.navigationController.pushViewController(splashVC, animated: true)
    }
    
    func goToMain() {
        if sessionManager.isLoggedIn {
            
        }
        else {
            let onboardingVC: OnboardingVC = .instantiate()
            let vm: OnboardingVM = Resolver.shared.resolve(OnboardingVM.self)
            onboardingVC.configure(with: vm)
            
            UIView.transition(with: self.navigationController.view, duration: 0.3, options: .transitionCrossDissolve) {
                self.navigationController.setViewControllers([onboardingVC], animated: false)
            }
        }
    }
}
