//
//  SegmentedControlTests.swift
//  MobileCoreTests
//
//  Created by Praveen Prabhakar on 12/07/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreUI)
import CoreUI
import CoreUtility
#endif
import XCTest

final class SegmentedControlTests: XCTestCase {
    func testSegmentHandler() {
        // let
        let items = ["title 1", "title 2"]
        var completionBlock: SegmentedHandler?
        #if !canImport(CoreUI)
        let promise = expectation(description: "Segment completionBlock invoked")
        completionBlock = { _ in
            promise.fulfill()
        }
        #else
        completionBlock = { _ in
            // Do Nothing
        }
        #endif
        // when
        let segmentControl = UISegmentedControl(items: items, completionHandler: completionBlock)
        // test if handler is called
        segmentControl.sendActions(for: .valueChanged)
        // then
        XCTAssertNotNil(segmentControl.handler)
        #if !canImport(CoreUI)
        wait(for: [promise], timeout: 5)
        #endif
    }
}
