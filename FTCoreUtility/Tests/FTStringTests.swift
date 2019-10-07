//
//  FTStringTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen P on 06/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

class FTStringTests: XCTestCase {
    
    func testStringTrim() {
        var testString = "Test trimming"
        let trimmingTest = "Test "
        let trimming_Result = "trimming"
        
        XCTAssertEqual(testString.trimming(trimmingTest), trimming_Result)
        XCTAssertEqual(testString.trimingPrefix(trimmingTest), trimming_Result)
        
        testString.trimPrefix(trimmingTest)
        XCTAssertEqual(testString, trimming_Result)
        
        testString = "trimming array of string"
        XCTAssertEqual(testString.trimming([" array of"," string"]), trimming_Result)
        
        testString = "trimming string"
        XCTAssertEqual(testString.trimming(" string"), trimming_Result)
    }
    
    func testSubString() {
        let string = "test substring"
        XCTAssertEqual(string.substring(from: 0, to: 4), "test")
    }
    
    func testBundle() {
        XCTAssertNotNil(FTMobileCoreBundle.bundle())
    }
    
    func testBundlePath() {
        let path = FTMobileCoreBundle.bundle()?.path(forResource: "Themes", ofType: "json")
        
        let promise = expectation(description: "Files found at path.")
        try? path?.filesAtPath({ (paths) in
            XCTAssertNotNil(paths)
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
    }
}
