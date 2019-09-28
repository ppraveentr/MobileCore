//
//  FTThemesTests.swift
//  FTCoreUtilityTests
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

class FTThemesTests: XCTestCase {
    
    let theme: [String: Any] = [
        "type": "Themes",
        "color": [
            "default": "#FFFFFF",
            "black": "#FFFFFF",
            "white": "#000000",
            "halfwhite": "#FF00FFBF"
        ],
        "font": [
            "default": [
                "name": "system",
                "size": "13.0"
            ],
            "system14": [
                "_super": "default",
                "size": "14.0"
            ]
        ],
        "appearance": [
            "UINavigationBar:UINavigationController": [
                "barTintColor": "white",
                "tintColor": "white",
                "isTranslucent": false,
                "backgroundImage": [
                    "default": "@Pixel",
                    "landScape": "@Pixel"
                ],
                "shadowImage": "@empty"
            ],
            "UINavigationBar": [
                "barTintColor": "black",
                "isTranslucent": true
            ],
            "UISegmentedControl": [
                "tintColor": "black"
            ]
        ],
        "components": [
            "FTLabel": [
                "default": [
                    "text": [
                        "font": "system14",
                        "color": "black"
                    ],
                    "underline": false
                ],
                "system14W": [
                    "text": [
                        "font": "system14",
                        "color": "white"
                    ],
                    "underline": true
                ]
            ],
            "FTUISearchBar": [
                "default": [
                    "textcolor": "white",
                    "tintColor": "white",
                    "barTintColor": "navBarRed"
                ]
            ]
        ]
    ]
    
    override func setUp() {
        super.setUp()
        FTThemesManager.setupThemes(themes: theme)
    }
    
    // MARK: View Component
    func testComponent() {
        let value = FTThemesManager.getViewComponent("FTLabel", styleName: "system14W")
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
        XCTAssertEqual(value?.hexString(), "#FF00FF".lowercased(), "color should be equal")
        XCTAssertEqual(value?.hexAlphaString(), "#FF00FF00".lowercased(), "hex Value should be equal")
        let actualValue = UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 0.0)
        XCTAssertEqual(value, actualValue, "color should be equal")
    }
    
    func testRGBIntColor() {
        let value = UIColor(rgb: 13158600)
        XCTAssertNotNil(value)
        XCTAssertEqual(value.hexString(), "#C8C8C8".lowercased(), "color should be equal")
        XCTAssertEqual(value.hexAlphaString(), "#C8C8C8FF".lowercased(), "hex Value should be equal")
        let actualValue = UIColor(red: 200, green: 200, blue: 200, a: 1.0)
        XCTAssertEqual(value.hexString(), actualValue.hexString(), "color should be equal")
    }
    
    func testRGBAIntColor() {
        let value = UIColor(rgb: 13158600, a: 0.5)
        XCTAssertNotNil(value)
        XCTAssertEqual(value.hexAlphaString(), "#C8C8C87F".lowercased(), "hex Value should be equal")
        let actualValue = UIColor(red: 200, green: 200, blue: 200, a: 0.5)
        XCTAssertEqual(value.hexAlphaString(), actualValue.hexAlphaString(), "color should be equal")
    }
    
    // MARK: appearance
    func testAppearance() {
        let value = FTThemesManager.getAppearance()
        ftLog("\n getAppearance : ", value ?? "nil")
        XCTAssertNotNil(value)
    }
    
    func testAppearanceNavigationBar() {
        let value = FTThemesManager.getAppearance("UINavigationBar") as? FTThemeModel
        XCTAssertNotNil(value)
        XCTAssertTrue(value?.count == 2, "Valid no themes not found")
    }

    func testFTUISearchBar() {
        let value: FTThemeModel? = FTThemesManager.getViewComponent("FTUISearchBar", styleName: "default")
        XCTAssertNotNil(value)
        XCTAssertTrue(value?.count == 3, "Valid no themes not found")
    }
}
