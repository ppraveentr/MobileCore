//
//  SegmentedControlTests.swift
//  CoreComponentsTests
//
//  Created by Praveen Prabhakar on 12/07/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreComponents)
import CoreComponents
import CoreUtility
#endif
import XCTest

final class SegmentedControlTests: XCTestCase {
    func testSegmentHandler() {
        // let
        let items = ["title 1", "title 2"]
        // let promise = expectation(description: "Segment completionBlock invoked")
        let segmentControl = UISegmentedControl(items: items) { _ in
            // promise.fulfill()
        }
        // when: test if handler is called
        segmentControl.selectedSegmentIndex = 1
        // then
        XCTAssertNotNil(segmentControl.handler)
        // TODO: Fix it
        // wait(for: [promise], timeout: 5)
    }
}
