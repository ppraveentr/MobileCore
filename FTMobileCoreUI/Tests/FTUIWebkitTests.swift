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

    func testExample() {
        let webView = WKWebView()
        webView.setScrollEnabled(enabled: true)
    }
    
    func testContentView() {
        let contentView: FTContentView? = FTContentView()
        XCTAssertNotNil(contentView?.webView)
    }
}
