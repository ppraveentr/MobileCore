//
//  FTThemesTests.swift
//  FTCoreUtilityTests
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

@testable import FTMobileCoreSample
import XCTest

class FTThemesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        if
            let theme = Bundle(for: type(of: self)).path(forResource: "Themes", ofType: "json"),
            let themeContent: FTThemeModel = try? theme.jsonContentAtPath()
        {
            FTThemesManager.setupThemes(themes: themeContent, imageSourceBundle: nil)
        }
        else {
            XCTFail()
        }
    }
    
    // MARK: View Component
    func testComponent() {
        let value = FTThemesManager.getViewComponent("FTLabel", styleName: "system14R")
        XCTAssertNotNil(value)
    }
    
    // MARK: Font
    func testFonts() {
        let value = FTThemesManager.getFont("system14")
        XCTAssertNotNil(value)
    }
    
    // MARK: Color
    func testColorWhite() {
        let value = FTThemesManager.getColor("white")
        XCTAssertNotNil(value)
    }
    
    func testColorFailToDefault() {
        let value = FTThemesManager.getColor("orange")
        let defaultValue = FTThemesManager.getColor("default")
        XCTAssertEqual(value, defaultValue, "color should be default to black")
    }
    
    func testHashColor() {
        let value = FTThemesManager.getColor("#F3F3F3F8")
        XCTAssertNotNil(value)
    }
    
    func testHexColor() {
        let value = UIColor.hexColor("#FF00FF00")
        XCTAssertNotNil(value)
        XCTAssertEqual(value?.hexString(), "#FF00FF".lowercased())
        XCTAssertEqual(value?.hexAlphaString(), "#FF00FF00".lowercased())
        let actualValue = UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 0.0)
        XCTAssertEqual(value, actualValue, "color should be equal")
    }
    
    func testRGBIntColor() {
        let value = UIColor(rgb: 13158600)
        XCTAssertNotNil(value)
        XCTAssertEqual(value.hexString(), "#C8C8C8".lowercased())
        XCTAssertEqual(value.hexAlphaString(), "#C8C8C8FF".lowercased())
        let actualValue = UIColor(red: 200, green: 200, blue: 200, a: 1.0)
        XCTAssertEqual(value.hexString(), actualValue.hexString())
    }
    
    func testRGBAIntColor() {
        let value = UIColor(rgb: 13158600, a: 0.5)
        XCTAssertNotNil(value)
        XCTAssertEqual(value.hexAlphaString(), "#C8C8C87F".lowercased())
        let actualValue = UIColor(red: 200, green: 200, blue: 200, a: 0.5)
        XCTAssertEqual(value.hexAlphaString(), actualValue.hexAlphaString())
    }
    
    func testLighterColor() {
        let value = UIColor.black.lighterColor(10)
        XCTAssertEqual(value.hexAlphaString(), UIColor.white.hexAlphaString())
        // fail case
        let lvalue = UIColor.black.lighterColor(-10)
        XCTAssertEqual(lvalue.hexAlphaString(), UIColor.black.hexAlphaString())
    }
    
    func testDarkerColor() {
        let value = UIColor.white.darkerColor(10)
        XCTAssertEqual(value.hexAlphaString(), UIColor.black.hexAlphaString())
        // fail case
        let dvalue = UIColor.white.darkerColor(-10)
        XCTAssertEqual(dvalue.hexAlphaString(), UIColor.white.hexAlphaString())
    }
    
    // MARK: appearance
    func testAppearance() {
        let value = FTThemesManager.getAppearance()
        XCTAssertNotNil(value)
    }
    
    func testAppearanceNavigationBar() {
        let value = FTThemesManager.getAppearance("UINavigationBar") as? FTThemeModel
        XCTAssertNotNil(value)
        XCTAssertTrue(value?.count == 2)
    }

    func testFTUISearchBar() {
        let value: FTThemeModel? = FTThemesManager.getViewComponent("FTSearchBar", styleName: "default")
        XCTAssertNotNil(value)
        XCTAssertTrue(value?.count == 3)
    }
}
