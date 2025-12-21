//
//  HomeCoordinator.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 8/12/2568 BE.
//

import Foundation
import UIKit

@MainActor
final class HomeCoordinator: Coordinator {
    
    weak var parent: AppCoordinator?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let indexVC: IndexVC = .instantiate()
        self.navigationController.pushViewController(indexVC, animated: true)
    }
    
    func showLogin() {
        
    }
    
    func showRegister() {
        
    }
}
