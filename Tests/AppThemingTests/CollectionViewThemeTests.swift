//
//  CollectionViewThemeTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 30/06/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

#if canImport(AppTheming)
import AppTheming
import CoreComponents
import CoreUtility
#endif
import Foundation
import UIKit
import XCTest

final class CollectionViewThemeTests: XCTestCase {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func setUp() {
        super.setUp()
        if let themeContent: ThemeModel = try? AppThemingTestsUtility.kThemePath?.jsonContentAtPath() {
            ThemesManager.setupThemes(themes: themeContent)
        }
        else {
            XCTFail("Should have valid theme")
        }
    }
    
    func testCollectionViewBackgroundViewTheme() {
        // let
        let tempView = FTView(frame: .zero)
        let value = ThemesManager.getColor("red")
        // when
        collectionView.backgroundView = tempView
        collectionView.theme = "collectionRed"
        // then
        XCTAssertNotNil(value, "Should have valid value")
        XCTAssertEqual(tempView.theme, "viewR")
        XCTAssertEqual(tempView.backgroundColor, value, "Should have same backgroundColor")
    }
    
    func testCollectionViewTheme() {
        // let
        let tempView = FTView(frame: .zero)
        let value = ThemesManager.getColor("white")
        // when
        collectionView.backgroundView = tempView
        collectionView.theme = ThemeStyle.defaultStyle.rawValue
        // then
        XCTAssertNotNil(value, "Should have valid value")
        XCTAssertEqual(tempView.theme, ThemeStyle.defaultStyle.rawValue)
        XCTAssertEqual(tempView.backgroundColor, value)
    }
}
