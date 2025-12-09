//
//  HomeCoordinator.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 8/12/2568 BE.
//

import Foundation
import UIKit

final class HomeCoordinator: Coordinator {
    
    weak var parent: AppCoordinator?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func showLogin() {
        
    }
    
    func showRegister() {
        
    }
}
