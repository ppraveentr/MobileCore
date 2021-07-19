//
//  LoadingIndicatorTests.swift
//  MobileCoreTests
//
//  Created by Praveen Prabhakar on 12/07/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreComponents)
import CoreComponents
import CoreUtility
#endif
import XCTest

final class LoadingIndicatorTests: XCTestCase {
    func testLoadingIndicator() {
        // when
        LoadingIndicator.show()
        // then
        let laodingIndicator: LoadingIndicator? = UIApplication.shared.keyWindow?.findInSubView()
        if UIApplication.shared.keyWindow != nil {
            XCTAssertNotNil(laodingIndicator)
        }
    }
    
    // Need to be moved to UI Test
    func testShowLoadingIndicator() {
        // let
        let viewController = UIViewController()
        let promise = expectation(description: "Loading Indicator Hidden")
        // when
        viewController.showActivityIndicator()
        // then
        let laodingIndicator: LoadingIndicator? = UIApplication.shared.keyWindow?.findInSubView()
        if UIApplication.shared.keyWindow != nil {
            XCTAssertNotNil(laodingIndicator)
        }
        // when
        viewController.hideActivityIndicator { _ in
            promise.fulfill()
        }
        // then
        wait(for: [promise], timeout: 15)
    }
}
