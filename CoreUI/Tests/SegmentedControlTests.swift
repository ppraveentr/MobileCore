//
//  SegmentedControlTests.swift
//  MobileCoreTests
//
//  Created by Praveen Prabhakar on 12/07/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

final class SegmentedControlTests: XCTestCase {
    func testSegmentHandler() {
        // let
        let promise = expectation(description: "Segment completionBlock invoked")
        let items = ["title 1", "title 2"]
        let completionBlock: SegmentedHandler = { _ in
            promise.fulfill()
        }
        // when
        let segmentControl = UISegmentedControl(items: items, completionHandler: completionBlock)
        // test if handler is called
        segmentControl.sendActions(for: .valueChanged)
        // then
        XCTAssertNotNil(segmentControl.handler)
        wait(for: [promise], timeout: 5)
    }
}
