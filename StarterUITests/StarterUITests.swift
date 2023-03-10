//
//  StarterUITests.swift
//  StarterUITests
//
//  Created by Ye Lynn Htet on 29/01/2022.
//

import XCTest

class StarterUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_homeView_clickMovieItem_goToMovieDetailView() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.tables.children(matching: .any).element(boundBy: 0).tap()
        
        let navBarTitle = app.navigationBars.buttons.element(boundBy: 0)
        
        
        XCTAssert(navBarTitle.waitForExistence(timeout: 5))
        
        XCTAssertTrue(!navBarTitle.label.isEmpty)
        
        
    }
    
    func test_search_withValidInput_returnsRelatedSearchResults() {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["search_button"].tap()
        
        let searchField = app.navigationBars.searchFields.element
        XCTAssert(searchField.waitForExistence(timeout: 5))
        
        app.searchFields.element.tap()
        app.typeText("Spider")
        
        let firstCell = app.collectionViews.children(matching: .any).element(boundBy: 0)
        XCTAssert(firstCell.waitForExistence(timeout: 5))
    }
    


}
