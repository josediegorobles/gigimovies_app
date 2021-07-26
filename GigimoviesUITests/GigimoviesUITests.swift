//
//  GigimoviesUITests.swift
//  GigimoviesUITests
//
//  Created by user201376 on 7/25/21.
//

import XCTest

class GigimoviesUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFavoritesTab() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let tablesQuery = app.tables
        tablesQuery.cells["Viuda negra, favorite"].buttons["button"].tap()
        
        let favoriteButton = tablesQuery.cells["La guerra del mañana, favorite"].buttons["button"]
        favoriteButton.tap()
        app.tabBars["Tab Bar"].buttons["Favoritas"].tap()
        let tablesQueryFavorites = app.tables
        print(tablesQueryFavorites.cells.count )
        XCTAssertGreaterThan(tablesQueryFavorites.cells.count, 0)
        
        
    }
    
    func testStarInMoviesTab() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let tablesQuery = app.tables
        let button = tablesQuery.cells["Space Jam: Nuevas leyendas, favorite"].buttons["button"]
        XCTAssertTrue(button.exists)
        button.tap()
        let highlighted = tablesQuery.cells["Space Jam: Nuevas leyendas, favorite"].buttons["highlighted"]
        XCTAssertTrue(highlighted.exists)
        highlighted.tap()
        XCTAssertTrue(button.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
