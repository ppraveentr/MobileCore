//
//  ActionBlockTests.swift
//  CoreUtilityTests
//
//  Created by Praveen P on 07/09/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//
import XCTest

final class ActionBlockTests: XCTestCase {
    
    func testTapActionBlock() {
        let promise = expectation(description: "Action block tap worked.")

        let tapAction = UIControl()
        // add action block
        tapAction.addTapActionBlock {
            promise.fulfill()
        }
        // trigger tap actionBlock
        tapAction.actionBlockTapped()
        // wait for promise fulfill
        wait(for: [promise], timeout: 5)
    }
}
