//
//  ContentViewProtocolTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen P on 09/11/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest
import WebKit

class ContentViewProtocolTests: XCTestCase {
    
    final class ContentViewController: UIViewController, FTContentViewControllerProtocol {
    }
    
    let contentVC = ContentViewController()
    
    func testContentViewDefaults() {
        XCTAssertNotNil(contentVC)
        XCTAssertEqual(contentVC.contentView, contentVC.contentView)
        let webView = WKWebView()
        contentVC.contentView = webView
        XCTAssertEqual(contentVC.contentView, webView)
    }
}
