//
//  FTUIWebkitTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 17/08/19.
//  Copyright © 2019 Praveen P. All rights reserved.
//

@testable import MobileCore
import WebKit
import XCTest

class FTUIWebkitTests: XCTestCase {

    let testHTMLString = "Test load string"
    
    lazy var webview: WKWebView = WKWebView()

    override func setUp() {
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
        webview.setContentFontSize(20.0)
        
        let promise = expectation(description: "Valid text size.")
        webview.getTextSize { (size) in
            if size == 20.0 {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testHTMLTextColor() {
        webview.setContentColor(textColor: UIColor.red, backgroundColor: UIColor.green)
        
        let textColorPromise = expectation(description: "Valid text color.")
        webview.getHTMLColor { textColor, bgColor in
            if textColor == UIColor.red, bgColor == UIColor.green {
                textColorPromise.fulfill()
            }
        }
        wait(for: [textColorPromise], timeout: 5)
    }
    
    func testHTMLFont() {
        webview.setContentFontFamily("Arial")
        
        let promise = expectation(description: "Valid text font.")
        webview.getContentFontFamily { fonts in
            if fonts.contains("Arial") {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }
}
