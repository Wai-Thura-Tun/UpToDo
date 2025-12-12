//
//  AppCoordinatorTests.swift
//  UpToDoTests
//
//  Created by Wai Thura Tun on 11/12/2568 BE.
//

import XCTest
@testable import UpToDo

final class AppCoordinatorTests: XCTestCase {
    
    var coordinator: AppCoordinator!
    var mockSessionManager: MockSessionManager!
    var mockNC: MockNC!
    
    override func setUp() {
        super.setUp()
        
        self.mockSessionManager = .init()
        self.mockNC = .init()
        self.coordinator = AppCoordinator(
            navigationController: mockNC,
            sessionManager: mockSessionManager
        )
    }
    
    func test_shouldAlwaysShowSplashScreenWhenLogin() {
        self.mockSessionManager.isLoggedIn = true
        
        self.coordinator.start()
        
        XCTAssertTrue(self.mockNC.pushedViewController.first is SplashVC)
    }
    
    func test_shouldAlwaysShowSplashScreenWhenLogout() {
        self.mockSessionManager.isLoggedIn = false
        
        self.coordinator.start()
        
        XCTAssertTrue(self.mockNC.pushedViewController.first is SplashVC)
    }
    
    func test_shouldShowOnboardingVCForNewUser() {
        
        self.mockSessionManager.isLoggedIn = false
        self.mockSessionManager.isOldUser = false
        
        self.coordinator.didFinishSplash()
        
        XCTAssertTrue(self.mockNC.setViewControllers.last is OnboardingVC)
    }
    
    func test_shouldNotShowOnboardingVCForNewUser() {
        self.mockSessionManager.isLoggedIn = false
        self.mockSessionManager.isOldUser = true
        
        self.coordinator.didFinishSplash()
        
        XCTAssertFalse(self.mockNC.setViewControllers.last is OnboardingVC)
    }
    
    func test_shouldShowLoginScreenForNewUser() {
        self.mockSessionManager.isLoggedIn = false
        self.mockSessionManager.isOldUser = true
        
        self.coordinator.didFinishSplash()
        
        XCTAssertTrue(self.mockNC.pushedViewController.last is LoginVC)
        XCTAssertTrue(self.coordinator.childCoordinators.count == 1)
        XCTAssertTrue(self.coordinator.childCoordinators.first is AuthCoordinator)
    }
    
    func test_shouldNotShowLoginScreenForAuthenticatedUser() {
        self.mockSessionManager.isLoggedIn = true
        self.mockSessionManager.isOldUser = true
        
        self.coordinator.didFinishSplash()
        
        XCTAssertFalse(self.mockNC.pushedViewController.last is LoginVC)
        XCTAssertFalse(self.coordinator.childCoordinators.first is AuthCoordinator)
    }
    
    override func tearDown() {
        
        coordinator = nil
        mockSessionManager = nil
        mockNC = nil
        super.tearDown()
    }
}
