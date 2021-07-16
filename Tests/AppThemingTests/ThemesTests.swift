//
//  ThemesTests.swift
//  MobileCoreUtilityTests
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import AppTheming
import XCTest

final class ThemesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        if let themeContent: ThemeModel = try? Utility.kThemePath?.jsonContentAtPath() {
            ThemesManager.setupThemes(themes: themeContent, imageSourceBundle: [Utility.kMobileCoreBundle])
        }
        else {
            XCTFail("Should have valid theme")
        }
    }
    
    // MARK: Theme Manager
    
    // MARK: View Component
    func testComponent() {
        let value = ThemesManager.getViewComponent("UILabel", styleName: "system14R")
        XCTAssertNotNil(value)
    }
    
    // MARK: Font
    func testFonts() {
        let value = ThemesManager.getFont("system14")
        XCTAssertNotNil(value)
    }
    
    // MARK: Color
    func testColorWhite() {
        let value = ThemesManager.getColor("white")
        XCTAssertNotNil(value)
    }
    
    func testColorFailToDefault() {
        let value = ThemesManager.getColor("orange")
        let defaultValue = ThemesManager.getColor("default")
        XCTAssertEqual(value, defaultValue, "color should be default to black")
    }
    
    func testHashColor() {
        let value = ThemesManager.getColor("#F3F3F3F8")
        XCTAssertNotNil(value)
        XCTAssertEqual("#F3F3F3F8".hexColor(), value, "color should be equal")
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
        let value = UIColor(rgb: 13_158_600)
        XCTAssertNotNil(value)
        XCTAssertEqual(value.hexString(), "#C8C8C8".lowercased())
        XCTAssertEqual(value.hexAlphaString(), "#C8C8C8FF".lowercased())
        let actualValue = UIColor(red: 200, green: 200, blue: 200, a: 1.0)
        XCTAssertEqual(value.hexString(), actualValue.hexString())
    }
    
    func testRGBAIntColor() {
        let value = UIColor(rgb: 13_158_600, a: 0.5)
        XCTAssertNotNil(value)
        XCTAssertEqual(value.hexAlphaString(), "#C8C8C87F".lowercased())
        let actualValue = UIColor(red: 200, green: 200, blue: 200, a: 0.5)
        XCTAssertEqual(value.hexAlphaString(), actualValue.hexAlphaString())
    }
    
    // MARK: Image
    func testColorFromImage() {
        let image = UIImage.named("@TestImage")
        XCTAssertNotNil(image)
        
        let color = image?.getColor(a: 255.0)
        XCTAssertNotNil(color)
        XCTAssertEqual(color, UIColor(red: 1, green: 1, blue: 1, alpha: 1), "color should be white")
    }
    
    // MARK: appearance
    func testAppearance() {
        let value = ThemesManager.getAppearance()
        XCTAssertNotNil(value)
    }
    
    func testAppearanceNavigationBar() {
        let value = ThemesManager.getAppearance("UINavigationBar") as? ThemeModel
        XCTAssertNotNil(value)
        XCTAssertTrue(value?.count == 2)
    }

    func testSearchBar() {
        let value: ThemeModel? = ThemesManager.getViewComponent("UISearchBar", styleName: "default")
        XCTAssertNotNil(value)
        XCTAssertTrue(value?.count == 3)
    }
    
    // MARK: image
    func testImage() {
        let image = UIImage.named("@Pixel")
        XCTAssertNotNil(image)
    }
    
    // MARK: Layer
    func testLayer() {
        let value: ThemeModel? = ThemesManager.getLayer("elevated")
        XCTAssertNotNil(value)
    }
    
    func testLayerTheme() {
        let view = UIView()
        view.theme = "elevated"
        XCTAssertEqual(view.layer.shadowRadius, 5.0, "Should have valid shadowRadius")
        view.theme = "shadowOffset"
        XCTAssertEqual(view.layer.shadowOffset, CGSize(width: 5, height: 5), "Should have valid shadowRadius")
    }
}
