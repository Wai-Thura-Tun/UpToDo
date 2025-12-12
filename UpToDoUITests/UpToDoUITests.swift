//
//  UpToDoUITests.swift
//  UpToDoUITests
//
//  Created by Wai Thura Tun on 5/12/2568 BE.
//

import XCTest
@testable import UpToDo

final class UpToDoUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["UITestSkipSplash"]
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
        app = nil
    }

    @MainActor
    func test_Onboarding_BasicElementExist() throws {
        // UI tests must launch the application that they test.
        app.launchArguments.append("ResetUserDefault")
        app.launch()
        
        XCTAssertTrue(app.navigationBars.buttons["SKIP"].exists)
        XCTAssertTrue(app.images.firstMatch.exists)
        XCTAssertTrue(app.staticTexts.firstMatch.exists)
        XCTAssertTrue(app.staticTexts.element(boundBy: 1).exists)
        XCTAssertTrue(app.buttons["NEXT"].exists)
        XCTAssertTrue(app.buttons["BACK"].exists)
    }

    @MainActor
    func test_Onboarding_CompleteFlow() throws {
        app.launchArguments.append("ResetUserDefault")
        app.launch()
        
        for _ in 0..<2 {
            app.buttons["NEXT"].tap()
        }
        
        XCTAssertTrue(app.buttons["GET STARTED"].exists)
    }
    
    @MainActor
    func test_Onboarding_SkipFlow() throws {
        app.launchArguments.append("ResetUserDefault")
        app.launch()
        
        app.navigationBars.buttons["SKIP"].tap()
        XCTAssertFalse(app.buttons["NEXT"].exists)
    }
    
    @MainActor
    func test_Onboarding_BackFlow() throws {
        app.launchArguments.append("ResetUserDefault")
        app.launch()
        
        for _ in 0..<2 {
            app.buttons["NEXT"].tap()
        }
        
        app.buttons["BACK"].tap()
        XCTAssertFalse(app.buttons["GET STARTED"].exists)
    }
    
    @MainActor
    func test_Onboarding_CompletePersists() throws {
        app.launchArguments.append("ResetUserDefault")
        app.launch()
        
        for _ in 0..<2 {
            app.buttons["NEXT"].tap()
        }
        
        app.buttons["GET STARTED"].tap()
        
        app.terminate()
        
        app.launchArguments.removeAll()
        app.launch()
        
        XCTAssertFalse(app.navigationBars.buttons["SKIP"].exists)
        XCTAssertFalse(app.buttons["NEXT"].exists)
        XCTAssertFalse(app.buttons["BACK"].exists)
    }
    
    @MainActor
    func test_Onboarding_RapidButtonTaps() throws {
        app.launchArguments.append("ResetUserDefault")
        app.launch()
        
        app.buttons["NEXT"].tap()
        app.buttons["NEXT"].tap()
        
        XCTAssertTrue(app.buttons["NEXT"].exists || app.buttons["GET STARTED"].exists)
        XCTAssertTrue(app.navigationBars.buttons["SKIP"].exists)
        XCTAssertTrue(app.buttons["BACK"].exists)
    }
    
    @MainActor
    func test_Onboarding_BackgroundStore() throws {
        app.launchArguments.append("ResetUserDefault")
        app.launch()
        
        app.buttons["NEXT"].tap()
        
        XCUIDevice.shared.press(.home)
        sleep(2)
        
        app.activate()
        
        XCTAssertTrue(app.navigationBars.buttons["SKIP"].exists)
        XCTAssertTrue(app.buttons["NEXT"].exists)
        XCTAssertTrue(app.buttons["BACK"].exists)
    }
    
    
    @MainActor
    func test_Onboarding_MemoryUsage() throws {
        measure(metrics: [XCTMemoryMetric()]) {
            app.launchArguments += ["ResetUserDefault"]
            app.launch()
            
            for _ in 0..<2 {
                app.buttons["NEXT"].tap()
            }
            
            app.buttons["GET STARTED"].tap()
        }
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
