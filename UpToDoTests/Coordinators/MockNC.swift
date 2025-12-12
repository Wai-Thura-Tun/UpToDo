//
//  MockNC.swift
//  UpToDoTests
//
//  Created by Wai Thura Tun on 11/12/2568 BE.
//

import Foundation
import UIKit

final class MockNC: UINavigationController {
    var pushedViewController: [UIViewController] = []
    var setViewControllers: [UIViewController] = []
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController.append(viewController)
        super.pushViewController(viewController, animated: animated)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        self.setViewControllers = viewControllers
        super.setViewControllers(viewControllers, animated: animated)
    }
}
