//
//  OnboardingVM.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 5/12/2568 BE.
//

import Foundation

protocol OnboardingViewDelegate: AnyObject {
    func readyToUpdateSnapshot()
    func onboardingFinished()
}

@MainActor
final class OnboardingVM {
    
    private(set) var data: [Onboarding] = []
    private weak var delegate: OnboardingViewDelegate?
    private let sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    func setDelegate(_ delegate: OnboardingViewDelegate) {
        self.delegate = delegate
    }
    
    func getData() {
        self.data = Onboarding.data
        self.delegate?.readyToUpdateSnapshot()
    }
    
    func finishOnboarding() {
        self.sessionManager.setOldUser()
        self.delegate?.onboardingFinished()
    }
}
