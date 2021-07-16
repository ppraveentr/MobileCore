//
//  WebViewControllerProtocolTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 09/11/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

#if canImport(NetworkLayer)
@testable import CoreUI
@testable import CoreUtility
@testable import NetworkLayer
#endif
import WebKit
import XCTest

fileprivate final class MockKWebViewController: UIViewController, WebViewControllerProtocol {
    // Mock: object implementation for testing
}
   
final class WebViewControllerProtocolTests: XCTestCase {
    
    private let contentVC = MockKWebViewController()
    
    func testContentViewDefaults() {
        XCTAssertNotNil(contentVC)
        XCTAssertEqual(contentVC.contentView, contentVC.contentView)
        let webView = WKWebView()
        contentVC.contentView = webView
        XCTAssertEqual(contentVC.contentView, webView)
    }
}
