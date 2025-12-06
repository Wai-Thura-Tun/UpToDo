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
        if sessionManager.isLoggedIn {
            
        }
        else {
            let onboardingVC: OnboardingVC = OnboardingVC.instantiate()
            self.navigationController.pushViewController(onboardingVC, animated: true)
        }
    }
    
}
