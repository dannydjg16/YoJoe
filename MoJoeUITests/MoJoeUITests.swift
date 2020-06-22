//
//  MoJoeUITests.swift
//  MoJoeUITests
//
//  Created by Daniel Grant on 6/21/20.
//  Copyright © 2020 Daniel Grant. All rights reserved.
//

import XCTest

class MoJoeUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFeedPages() throws {
        
        let mojoeFeedswitcherNavigationBar = XCUIApplication().navigationBars["MoJoe.FeedSwitcher"]
        let shopsButton = mojoeFeedswitcherNavigationBar/*@START_MENU_TOKEN@*/.buttons["Shops"]/*[[".segmentedControls.buttons[\"Shops\"]",".buttons[\"Shops\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let debutButton = mojoeFeedswitcherNavigationBar/*@START_MENU_TOKEN@*/.buttons["Debut"]/*[[".segmentedControls.buttons[\"Debut\"]",".buttons[\"Debut\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let feedButton = mojoeFeedswitcherNavigationBar/*@START_MENU_TOKEN@*/.buttons["Feed"]/*[[".segmentedControls.buttons[\"Feed\"]",".buttons[\"Feed\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        if feedButton.isSelected {
            
            XCTAssertTrue(app.tables.element.exists)
            shopsButton.tap()
            
        } else if shopsButton.isSelected {
            
            XCTAssertTrue(app.tables.element.exists)
            debutButton.tap()
            
        } else if debutButton.isSelected {
            
            XCTAssertTrue(app.tables.element.exists)
        }
        
        
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
