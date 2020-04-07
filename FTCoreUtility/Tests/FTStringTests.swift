//
//  FTStringTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen P on 06/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCoreExample
import XCTest

class FTStringTests: XCTestCase {
        
    func testStringTrim() {
        var testString = "Test trimming"
        let trimmingTest = "Test "
        let trimmingResult = "trimming"
        
        XCTAssertEqual(testString.trimming(trimmingTest), trimmingResult)
        XCTAssertEqual(testString.trimingPrefix(trimmingTest), trimmingResult)
        
        testString.trimPrefix(trimmingTest)
        XCTAssertEqual(testString, trimmingResult)
        
        testString = "trimming array of string"
        XCTAssertEqual(testString.trimming([" array of"," string"]), trimmingResult)
        
        testString = "trimming string"
        XCTAssertEqual(testString.trimming(" string"), trimmingResult)
    }
    
    func testSubString() {
        let string = "test substring"
        XCTAssertEqual(string.substring(from: 0, to: 4), "test")
    }
    
    func testBundlePath() {
        XCTAssertNotNil(kFTMobileCoreBundle)
        let path = kFTMobileCoreBundle?.path(forResource: "Themes", ofType: "json")
        
        let promise = expectation(description: "Files found at path.")
        try? path?.filesAtPath({ (paths) in
            XCTAssertNotNil(paths)
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
    }
}
