//
//  AuthCoordinatorTests.swift
//  UpToDoTests
//
//  Created by Wai Thura Tun on 11/12/2568 BE.
//

import XCTest
@testable import UpToDo

final class AuthCoordinatorTests: XCTestCase {
    var coordinator: AuthCoordinator!
    var mockSessionManager: MockSessionManager!
    var mockNC: MockNC!
    
    override func setUp() {
        super.setUp()
        
        mockNC = .init()
        coordinator = .init(navigationController: mockNC)
    }
    
    func test_shouldStartWithLoginVC() {
        self.coordinator.start()
        
        XCTAssertTrue(self.mockNC.pushedViewController.count == 1)
        XCTAssertTrue(self.mockNC.pushedViewController.first is LoginVC)
    }
    
    override func tearDown() {
        coordinator = nil
        mockSessionManager = nil
        mockNC = nil
        
        super.tearDown()
    }
}
