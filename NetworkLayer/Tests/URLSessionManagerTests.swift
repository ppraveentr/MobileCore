//
//  URLSessionManagerTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 10/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

final class URLSessionManagerTests: XCTestCase {
    
    func testURLSession() {
        let session = URLSessionManager.createURLSession()
        XCTAssertNotNil(session)
        let delegate = session.delegate as? URLSessionManager
        XCTAssertNotNil(delegate)
        XCTAssertEqual(delegate, URLSessionManager.sharedInstance)
    }
    
    func testStartTask() {
        let task = URLSessionManager.startDataTask(with: URLRequest(url: URL(fileURLWithPath: "theme")))
        XCTAssertNotNil(task)
    }
    
    func testStartTaskWithCompletion() {
        let promise = expectation(description: "FTURLSession data task completed.")
        guard let theme = kThemePath else {
            XCTFail("Should have valid theme")
            return
        }
        URLSessionManager.startDataTask(with: URLRequest(url: URL(fileURLWithPath: theme))) { data, _, _ in
            XCTAssertNotNil(data)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
}
