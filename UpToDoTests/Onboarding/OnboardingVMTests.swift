//
//  OnboardingVMTests.swift
//  UpToDoTests
//
//  Created by Wai Thura Tun on 9/12/2568 BE.
//

import XCTest
@testable import UpToDo

final class MockOnboardingViewDelegate: OnboardingViewDelegate {
    
    var didCallReadyToUpdateSnapshot: Bool = false
    var didCallOnboardingFinished: Bool = false
    
    
    func readyToUpdateSnapshot() {
        didCallReadyToUpdateSnapshot = true
    }
    
    func onboardingFinished() {
        didCallOnboardingFinished = true
    }
}

final class OnboardingVMTests: XCTestCase {

    var vm: OnboardingVM!
    var sessionManager: MockSessionManager!
    var mockDelegate: MockOnboardingViewDelegate!
    
    override func setUp() {
        super.setUp()
        
        sessionManager = MockSessionManager()
        mockDelegate = MockOnboardingViewDelegate()
        vm = OnboardingVM(sessionManager: sessionManager)
        vm.delegate = mockDelegate
    }
    
    override func tearDown() {
        vm = nil
        sessionManager = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func test_populateDataAndNotifyDelegate() {
        // Populate Data and notify delegate
        
        guard let delegate = vm.delegate as? MockOnboardingViewDelegate else {
            return XCTAssertTrue(false, "Delegate is not MockOnboardingViewDelegate")
        }
        
        XCTAssertFalse(delegate.didCallReadyToUpdateSnapshot, "Delegate should not have called yet")
        
        vm.getData()
        
        XCTAssertTrue(delegate.didCallReadyToUpdateSnapshot, "Delegate should call after populate data")
    }
    
    func test_populateDataAndShouldEqualToExpected() {
        // Populate Data
        vm.getData()
        
        XCTAssertEqual(vm.data.count, Onboarding.data.count, "Data length inside view model should be equal to the data lenght of constant data of Onboarding Entity")
    }
    
    func test_finishOnboardingAndNotifyDelegate() {
        guard let delegate = vm.delegate as? MockOnboardingViewDelegate else {
            return XCTAssertTrue(false, "Delegate is not MockOnboardingViewDelegate")
        }
        
        XCTAssertFalse(delegate.didCallOnboardingFinished, "Delegate should not have called yet")
        
        vm.finishOnboarding()
        
        XCTAssertTrue(delegate.didCallOnboardingFinished, "Delegate should call after finish onboarding")
        
    }
}
