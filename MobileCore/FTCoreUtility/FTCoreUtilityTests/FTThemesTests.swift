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
        FTLog("\n FTLabel system14W : ", value ?? "nil")
        XCTAssertNotNil(value)
    }
    
    // MARK: Font
    func testFonts() {
        let value = FTThemesManager.getFont("system14")
        FTLog("\n font 14 : ", value ?? "nil")
        XCTAssertNotNil(value)
    }
    
    // MARK: Color
    func testColorWhite() {
        let value = FTThemesManager.getColor("white")
        FTLog("\n color white : ", value ?? "nil")
        XCTAssertNotNil(value)
    }
    
    func testColorFail() {
        let value = FTThemesManager.getColor("orange")
        let defaultValue = FTThemesManager.getColor("default")
        XCTAssertEqual(value, defaultValue, "color should be default to black")
    }
    
    func testHashColor() {
        let value = FTThemesManager.getColor("#F3F3F3F8")
        FTLog("\n color #FFFFFF00 : ", value ?? "nil")
        XCTAssertNotNil(value)
    }
    
    // MARK: appearance
    func testAppearance() {
        let value = FTThemesManager.getAppearance()
        FTLog("\n getAppearance : ", value ?? "nil")
        XCTAssertNotNil(value)
    }
    
//    func testAppearanceNavigationBar() {
//        let theme = FTThemesManager.getAppearance("UINavigationBar") as? [Any]
//        
//        XCTAssertNotNil(theme)
//        
//        XCTAssertTrue(theme?.count == 2, "Valid no themes not found")
//    }
//    
//    func testAppearanceSegmentedControl() {
//        let theme = FTThemesManager.getAppearance("UISegmentedControl") as? [Any]
//        
//        XCTAssertNotNil(theme)
//        
//        XCTAssertTrue(theme?.count == 1, "Valid no themes not found")
//    }

    func testFTUISearchBar() {

        let searchBar = FTUISearchBar(frame: .zero)
        searchBar.theme = "default"

        //let theme = FTThemesManager.getViewComponent("FTSearchBar", styleName: "default")

        //FTLog("\n FTSearchBar : ", theme ?? "nil")

//        XCTAssertNotNil(theme)

//        XCTAssertTrue(theme?.count == 1, "Valid no themes not found")
    }
}
