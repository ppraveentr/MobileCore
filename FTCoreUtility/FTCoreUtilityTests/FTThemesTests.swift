//
//  FTThemesTests.swift
//  FTCoreUtilityTests
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import XCTest
@testable import FTCoreUtility

class FTThemesTests: XCTestCase {
    
    let theme: [String : Any] = [
        "type": "Themes",
        "color": [
            "default": "#FFFFFF",
            "black": "#FFFFFF",
            "white": "#000000"
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
            ]
        ]
    ]
    
    override func setUp() {
        super.setUp()
        FTThemesManager.setupThemes(themes: theme)
    }
    
    func testComponent() {
        print("\n FTLabel system14W : ", FTThemesManager.getViewComponent("FTLabel", styleName: "system14W")!)
    }
    
    func testFonts() {
        print("\n font 14 : ", FTThemesManager.getFont("system14")!)
    }
    
    func testColorWhite() {
        print("\n color white : ", FTThemesManager.getColor("white")!)
    }
    
    func testColorBlack() {
        print("\n color black : ", FTThemesManager.getColor("black")!)
    }
    
    func testColorFail() {
        print("\n color fail : ", FTThemesManager.getColor("orange")!)
    }
    
    func testHashColor() {
        print("\n color #FFFFFF00 : ", FTThemesManager.getColor("#F3F3F3F8")!)
    }
}
