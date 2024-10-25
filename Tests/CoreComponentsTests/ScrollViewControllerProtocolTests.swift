//
//  ScrollViewControllerProtocolTests.swift
//  MobileCoreTests
//
//  Created by Praveen Prabhakar on 11/07/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreComponents)
import CoreComponents
import CoreUtility
#endif
import UIKit
import XCTest

private final class MockScrollViewController: UIViewController, ScrollViewControllerProtocol {
    // Optional Protocol implementation: intentionally empty
}

final class ScrollViewControllerProtocolTests: XCTestCase {
    
    private var scrollVC: MockScrollViewController!
    private var oldRootVC: UIViewController?
    
    override func setUp() {
        super.setUp()
        oldRootVC = UIApplication.shared.keyWindow?.rootViewController
        scrollVC = MockScrollViewController()
        UIApplication.shared.keyWindow?.rootViewController = scrollVC
    }
    
    override func tearDown() {
        super.tearDown()
        UIApplication.shared.keyWindow?.rootViewController = oldRootVC
    }
    
    func testScrollView() {
        XCTAssertNotNil(scrollVC.scrollView)
    }
    
    func testCustomScrollView() {
        let customScrollView = UIScrollView(frame: .zero)
        scrollVC.scrollView = customScrollView
        XCTAssertNotNil(scrollVC.scrollView)
        XCTAssertEqual(scrollVC.scrollView, customScrollView)
    }
}
