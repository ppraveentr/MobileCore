//
//  CustomUIElementsTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 16/08/19.
//  Copyright © 2019 Praveen P. All rights reserved.
//

@testable import MobileCore
import XCTest

final class CustomUIElementsTests: XCTestCase {
    private let titleString = "I’ve Became Able to Do Anything with My Heart Set.. Vol. 8 Ch. 207"
    
    override func setUp() {
        super.setUp()
        if
            let theme = kMobileCoreBundle?.path(forResource: "Themes", ofType: "json"),
            let themeContent: ThemeModel = try? theme.jsonContentAtPath()
        {
            ThemesManager.setupThemes(themes: themeContent, imageSourceBundle: nil)
        }
        else {
            XCTFail()
        }
    }
    
    // MARK: LabelFont
    func testLabelFont() {
        let label = UILabel(frame: .zero)
        label.text = titleString
        label.theme = "system14G"
        XCTAssert(label.font == UIFont.systemFont(ofSize: 14))
        XCTAssert(label.textColor == ThemesManager.getColor("green"))
    }
    
    // MARK: button
    func testButton() {
        let button = UIButton()
        button.setTitle(titleString, for: .normal)
        button.theme = "button14R"
        XCTAssert(button.titleLabel?.font == UIFont.systemFont(ofSize: 14))
        // enabled state
        XCTAssert(button.titleColor(for: .normal) == ThemesManager.getColor("red"))
        // highlighted state
        XCTAssert(button.titleColor(for: .highlighted) == ThemesManager.getColor("green"))
        // disabled state
        XCTAssert(button.titleColor(for: .disabled) == ThemesManager.getColor("yellow"))
        // default enabled state
        XCTAssertNil(button.getThemeSubType())
        // selected
        button.isSelected = true
        button.isEnabled = false
        XCTAssertEqual(button.getThemeSubType(), ThemeStyle.selectedStyle)
        // disabledStyle
        button.isSelected = false
        button.isEnabled = false
        XCTAssertEqual(button.getThemeSubType(), ThemeStyle.disabledStyle)
    }
}
