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
                ]
            ]
        ]
    ]
    
    override func setUp() {
        super.setUp()
        FTThemesManager.setupThemes(themes: theme)
    }
    
    func testFonts() {
        print("font 14 : ", FTThemesManager.getFont("system14")!)
    }
    
    func testColor() {
        print("color white : ", FTThemesManager.getColor("white")!)
    }
    
}
