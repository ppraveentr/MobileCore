//
//  FTUIElementsTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 17/08/19.
//  Copyright © 2019 Praveen P. All rights reserved.
//

@testable import MobileCore
import WebKit
import XCTest

class FTUIElementsTests: XCTestCase {

    func testExample() {
        let webView = WKWebView()
        webView.setScrollEnabled(enabled: true)
    }
    
    @objc func buttonAction() -> String{
        return "test_funtion"
    }
    
    func testNavigationBar() {
        let empty = FTNavigationBarItem()
        XCTAssertNil(empty)
        
        let title = FTNavigationBarItem(title: "title")
        XCTAssertNotNil(title)
        
        let view = FTNavigationBarItem(customView: UIView())
        XCTAssertNotNil(view)
        
        let action = FTNavigationBarItem(buttonAction: #selector(buttonAction), buttonType: .action)
        XCTAssertNotNil(action)
    }
}
