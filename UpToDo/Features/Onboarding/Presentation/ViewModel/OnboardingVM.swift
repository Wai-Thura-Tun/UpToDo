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

final class OnboardingVM {
    
    private(set) var data: [Onboarding] = []
    weak var delegate: OnboardingViewDelegate?
    private let sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
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
