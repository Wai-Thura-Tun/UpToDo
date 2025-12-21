//
//  SplashVC.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 8/12/2568 BE.
//

import UIKit

class SplashVC: UIViewController, Storyboarded {

    @IBOutlet weak var lblTitle: UILabel!
    
    private weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        startCountDown()
    }

    private func setupViews() {
        self.lblTitle.font = .popB32
    }
    
    private func startCountDown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.coordinator?.didFinishSplash()
        }
    }
    
    func configure(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
}
