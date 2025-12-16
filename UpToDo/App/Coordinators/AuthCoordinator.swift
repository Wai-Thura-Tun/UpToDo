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
        self.showLogin()
    }
    
    func showLogin() {
        let loginVC: LoginVC = .instantiate()
        let vm: LoginVM = Resolver.shared.resolve(LoginVM.self)
        loginVC.configure(with: vm, coordinator: self)
        self.navigationController.pushViewController(loginVC, animated: true)
    }
    
    func showRegister() {
        
    }
}
