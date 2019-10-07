//
//  FTUIElementTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 16/08/19.
//  Copyright © 2019 Praveen P. All rights reserved.
//

@testable import MobileCore
import XCTest

class FTUIElementTests: XCTestCase {
    
    let titleString = "I’ve Became Able to Do Anything with My Heart Set.. Vol. 8 Ch. 207"
    override func setUp() {
        super.setUp()
        if
            let theme = kFTMobileCoreBundle.bundle()?.path(forResource: "Themes", ofType: "json"),
            let themeContent: FTThemeModel = try? theme.jsonContentAtPath()
        {
            FTThemesManager.setupThemes(themes: themeContent, imageSourceBundle: nil)
        }
        else {
            XCTFail()
        }
    }
    
    // MARK: LabelFont
    func testLabelFont() {
        let label = FTLabel(frame: .zero)
        label.text = titleString
        label.theme = "system14G"
        XCTAssert(label.font == UIFont.systemFont(ofSize: 14))
        XCTAssert(label.textColor == FTThemesManager.getColor("green"))
    }
    
    // MARK: button
    func testButton() {
        let button = UIButton()
        button.setTitle(titleString, for: .normal)
        button.theme = "button14R"
        XCTAssert(button.titleLabel?.font == UIFont.systemFont(ofSize: 14))
        // enabled state
        XCTAssert(button.titleColor(for: .normal) == FTThemesManager.getColor("red"))
        // highlighted state
        XCTAssert(button.titleColor(for: .highlighted) == FTThemesManager.getColor("green"))
        // disabled state
        XCTAssert(button.titleColor(for: .disabled) == FTThemesManager.getColor("yellow"))
        // default enabled state
        XCTAssertNil(button.getThemeSubType())
        // selected
        button.isSelected = true
        button.isEnabled = false
        XCTAssertEqual(button.getThemeSubType(), FTThemeStyle.selectedStyle)
        // disabledStyle
        button.isSelected = false
        button.isEnabled = false
        XCTAssertEqual(button.getThemeSubType(), FTThemeStyle.disabledStyle)
    }
}
