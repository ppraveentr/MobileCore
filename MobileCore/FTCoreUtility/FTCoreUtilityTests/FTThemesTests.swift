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
        ftLog("\n FTLabel system14W : ", value ?? "nil")
        XCTAssertNotNil(value)
    }
    
    // MARK: Font
    func testFonts() {
        let value = FTThemesManager.getFont("system14")
        ftLog("\n font 14 : ", value ?? "nil")
        XCTAssertNotNil(value)
    }
    
    // MARK: Color
    func testColorWhite() {
        let value = FTThemesManager.getColor("white")
        ftLog("\n color white : ", value ?? "nil")
        XCTAssertNotNil(value)
    }
    
    func testColorFail() {
        let value = FTThemesManager.getColor("orange")
        let defaultValue = FTThemesManager.getColor("default")
        XCTAssertEqual(value, defaultValue, "color should be default to black")
    }
    
    func testHashColor() {
        let value = FTThemesManager.getColor("#F3F3F3F8")
        ftLog("\n color #FFFFFF00 : ", value ?? "nil")
        XCTAssertNotNil(value)
    }
    
    // MARK: appearance
    func testAppearance() {
        let value = FTThemesManager.getAppearance()
        ftLog("\n getAppearance : ", value ?? "nil")
        XCTAssertNotNil(value)
    }
    
    func testAppearanceNavigationBar() {
        let theme = FTThemesManager.getAppearance("UINavigationBar") as? FTThemeModel
        XCTAssertNotNil(theme)
        XCTAssertTrue(theme?.count == 2, "Valid no themes not found")
    }

    func testFTUISearchBar() {
        let theme: FTThemeModel? = FTThemesManager.getViewComponent("FTUISearchBar", styleName: "default")
        XCTAssertNotNil(theme)
        XCTAssertTrue(theme?.count == 3, "Valid no themes not found")
    }
}
