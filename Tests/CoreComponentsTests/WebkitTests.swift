//
//  WebkitTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 17/08/19.
//  Copyright © 2019 Praveen P. All rights reserved.
//

#if canImport(CoreComponents)
import CoreComponents
import CoreUtility
#endif
import WebKit
import XCTest

final class WebkitTests: XCTestCase {

    private let testHTMLString = "Test load string"
    
    lazy var webview = WKWebView()

    override func setUp() {
        super.setUp()
        webview.loadHTMLBody(testHTMLString)
    }
    
    func testContentView() {
        XCTAssertNotNil(webview)
    }
    
    func testScrollEnabled() {
        webview.setScrollEnabled(enabled: false)
        XCTAssertFalse(webview.scrollView.isScrollEnabled)
    }
    
    func testHTMLTextSize() {
        // let
        webview.setContentFontSize(20.0)
        // then
        let promise = expectation(description: "Valid text size.")
        webview.getTextSize { size in
            XCTAssertEqual(size, 20.0)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 15)
    }
    
    func testHTMLTextColor() {
        // let
        webview.setContentColor(textColor: UIColor.red, backgroundColor: UIColor.green)
        // then
        let textColorPromise = expectation(description: "Valid text color.")
        webview.getHTMLColor { textColor, bgColor in
             XCTAssertEqual(textColor, UIColor.red)
             XCTAssertEqual(bgColor, UIColor.green)
            textColorPromise.fulfill()
        }
        wait(for: [textColorPromise], timeout: 15)
    }
    
    func testHTMLFont() {
        // let
        webview.setContentFontFamily("Arial")
        // then
        let promise = expectation(description: "Valid text font.")
        webview.getContentFontFamily { fonts in
            XCTAssertTrue(fonts.contains("Arial"))
            promise.fulfill()
        }
        wait(for: [promise], timeout: 15)
    }
}
