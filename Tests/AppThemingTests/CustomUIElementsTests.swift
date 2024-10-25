//
//  CustomUIElementsTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 16/08/19.
//  Copyright © 2019 Praveen P. All rights reserved.
//

#if canImport(AppTheming)
import AppTheming
#endif
import XCTest

final class CustomUIElementsTests: XCTestCase {
    private let titleString = "I’ve Became Able to Do Anything with My Heart Set.. Vol. 8 Ch. 207"
    
    override func setUp() {
        super.setUp()
        if let themeContent: ThemeModel = try? AppThemingTestsUtility.kThemePath?.jsonContentAtPath() {
            ThemesManager.setupThemes(themes: themeContent, imageSourceBundle: nil)
        }
        else {
            XCTFail("Should have valid theme")
        }
    }
    
    // MARK: LabelFont
    func testUILabelTheme() {
        let label = UILabel(frame: .zero)
        label.text = titleString
        label.theme = "systemW14G"
        // systemFont
        XCTAssert(label.font == UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 1.0)))
        XCTAssert(label.textColor == ThemesManager.getColor("green"))
        // boldSystemFont
        label.theme = "systemB14R"
        XCTAssert(label.font == UIFont.boldSystemFont(ofSize: 14))
        // italicSystemFont
        label.theme = "systemI14R"
        XCTAssert(label.font == UIFont.italicSystemFont(ofSize: 14))
    }
    
    // MARK: button
    func testUIButtonTheme() {
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
        XCTAssertNil(button.subStyleName())
        // selected
        button.isSelected = true
        button.isEnabled = false
        XCTAssertEqual(button.subStyleName(), ThemeStyle.selectedStyle)
        // disabledStyle
        button.isSelected = false
        button.isEnabled = false
        XCTAssertEqual(button.subStyleName(), ThemeStyle.disabledStyle)
    }
    
    // MARK: SearchBar
    func testUISearchBarTheme() {
        // let
        let white = ThemesManager.getColor("white")
        let bar = UISearchBar(frame: .zero)
        bar.text = titleString
        bar.theme = ThemeStyle.defaultStyle.rawValue
        XCTAssertEqual(bar.barTintColor, ThemesManager.getColor("navBarRed"))
        XCTAssertEqual(bar.tintColor, white)
        if #available(iOS 13.0, *) {
            XCTAssertEqual(bar.searchTextField.textColor, white)
        }
    }
    
    // MARK: SegmentedControl
    func testUISegmentedControlTheme() {
        // let
        let white = ThemesManager.getColor("navBarRed")
        let segment = UISegmentedControl(items: ["item1", "item2"])
        segment.theme = ThemeStyle.defaultStyle.rawValue
        XCTAssertEqual(segment.tintColor, white)
    }
}
