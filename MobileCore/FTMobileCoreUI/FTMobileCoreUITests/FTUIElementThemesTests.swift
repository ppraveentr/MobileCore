//
//  FTUIElementsTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 16/08/19.
//  Copyright © 2019 Praveen P. All rights reserved.
//

@testable import MobileCore
import XCTest

class FTUIElementThemesTests: XCTestCase {

    let theme: FTThemeModel = [
        "type": "Themes",
        "color": [
            "default": "#FFFFFF",
            "black": "#FFFFFF",
            "white": "#000000",
            "pink": "#cf91cf"
        ],
        "font": [
            "default": [
                "name": "system",
                "size": "13.0"
            ],
            "system14": [
                "_super": "default",
                "size": "14.0"
            ],
            "system19": [
                "_super": "default",
                "size": "19.0"
            ]
        ],
        "components": [
            "FTLabel": [
                "default": [
                    "textfont": "system14",
                    "textcolor": "black",
                    "underline": false
                ],
                "system14W": [
                    "textfont": "system14",
                    "textcolor": "white",
                    "underline": true
                ],
                "system19P": [
                    "textfont": "system19",
                    "textcolor": "pink",
                    "underline": true
                ]
            ]
        ]
    ]
    
    override func setUp() {
        super.setUp()
        FTThemesManager.setupThemes(themes: theme)
    }
    
    // MARK: LabelFont
    func testLabelFont() {
        //            "name": "I’ve Became Able to Do Anything with My Growth Che.. Vol. 8 Ch. 207",
        let label = FTLabel(frame: .zero)
        label.text = "I’ve Became Able to Do Anything with My Heart Set.. Vol. 8 Ch. 207"
        label.theme = "system19P"
        XCTAssert(label.font == UIFont.systemFont(ofSize: 19), "Invalid font size for label")
        XCTAssert(label.textColor == UIColor(red: 207, green: 145, blue: 207, a: 1.0), "Invalid text color for label")
    }
}
