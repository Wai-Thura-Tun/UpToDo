//
//  AuthCoordinator.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 8/12/2568 BE.
//

import Foundation
import UIKit

final class AuthCoordinator: Coordinator {
    
    weak var parent: Coordinator?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginVC: LoginVC = .instantiate()
        self.navigationController.pushViewController(loginVC, animated: true)
    }
    
    func showLogin() {
        
    }
}
