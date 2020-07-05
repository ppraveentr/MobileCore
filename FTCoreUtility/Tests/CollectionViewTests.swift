//
//  CollectionViewTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 30/06/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import UIKit
import XCTest

final class CollectionViewTests: XCTestCase {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func setUp() {
        super.setUp()
        if
            let theme = kMobileCoreBundle?.path(forResource: "Themes", ofType: "json"),
            let themeContent: ThemeModel = try? theme.jsonContentAtPath()
        {
            ThemesManager.setupThemes(themes: themeContent)
        }
        else {
            XCTFail()
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
        XCTAssertNotNil(value)
        XCTAssertEqual(tempView.theme, "viewR")
        XCTAssertEqual(tempView.backgroundColor, value)
    }
    
    func testCollectionViewTheme() {
        // let
        let tempView = FTView(frame: .zero)
        let value = ThemesManager.getColor("white")
        // when
        collectionView.backgroundView = tempView
        collectionView.theme = ThemeStyle.defaultStyle
        // then
        XCTAssertNotNil(value)
        XCTAssertEqual(tempView.theme, ThemeStyle.defaultStyle)
        XCTAssertEqual(tempView.backgroundColor, value)
    }
}
