//
//  DTPremissionKitUITest.swift
//  DTPermissionKitTests
//
//  Created by Eden on 2021/8/19.
//

import XCTest

class DTPremissionKitUITest: XCTestCase {

    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        self.continueAfterFailure = false
        
        self.addUIInterruptionMonitor(withDescription: "Location Services") {
            
            let allowButton: XCUIElement = $0.buttons["Allow"]
            guard allowButton.exists else {
                
                return false
            }
            
            allowButton.tap()
            
            return true
        }
            
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
