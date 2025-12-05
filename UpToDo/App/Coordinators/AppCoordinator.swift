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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardingVC: OnboardingVC = OnboardingVC.instantiate()
        self.navigationController.pushViewController(onboardingVC, animated: true)
    }
    
}
