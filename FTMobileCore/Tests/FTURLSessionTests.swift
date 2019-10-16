//
//  FTURLSessionTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen P on 10/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

class FTURLSessionTests: XCTestCase {
    
    func testURLSession() {
        let session = FTURLSession.createURLSession()
        XCTAssertNotNil(session)
        let delegate = session.delegate as? FTURLSession
        XCTAssertNotNil(delegate)
        XCTAssertEqual(delegate, FTURLSession.sharedInstance)
    }
    
    func testStartTask() {
        let task = FTURLSession.startDataTask(with: URLRequest(url: URL(fileURLWithPath: "theme")))
        XCTAssertNotNil(task)
    }
    
    func testStartTaskWithCompletion() {
        let promise = expectation(description: "FTURLSession data task completed.")
        guard let theme = kFTMobileCoreBundle.bundle()?.path(forResource: "Themes", ofType: "json") else {
            XCTFail()
            return
        }
        FTURLSession.startDataTask(with: URLRequest(url: URL(fileURLWithPath: theme))) { data, _, _ in
            XCTAssertNotNil(data)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
}
