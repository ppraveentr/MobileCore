//
//  WebViewControllerProtocolTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 09/11/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest
import WebKit

fileprivate final class MockMockKWebViewController: UIViewController, WebViewControllerProtocol {
}
   
final class WebViewControllerProtocolTests: XCTestCase {
    
    private let contentVC = MockMockKWebViewController()
    
    func testContentViewDefaults() {
        XCTAssertNotNil(contentVC)
        XCTAssertEqual(contentVC.contentView, contentVC.contentView)
        let webView = WKWebView()
        contentVC.contentView = webView
        XCTAssertEqual(contentVC.contentView, webView)
    }
}
