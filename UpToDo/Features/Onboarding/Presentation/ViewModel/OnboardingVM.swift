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
    
    func getData() {
        self.data = Onboarding.data
        self.delegate?.readyToUpdateSnapshot()
    }
    
    func finishOnboarding() {
        UserDefaults.standard.setOldUser()
        self.delegate?.onboardingFinished()
    }
}
