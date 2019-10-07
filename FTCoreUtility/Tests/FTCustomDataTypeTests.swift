//
//  FTCustomDataTypeTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 07/09/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

class FTCustomDataTypeTests: XCTestCase {
    
    let testString = "Follow @krelborn or #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a>"
    let testUrl = "www.W3Schools.com"
    let testHash = "#visit"

    // MARK: String
    func testNilorEmpty() {
        var string: String?
        XCTAssertTrue(string.isNilOrEmpty)
        string = "random"
        XCTAssertFalse(string.isNilOrEmpty)
    }
    
    func testHTMLString() {
        let string = "<p>test</p>"
        XCTAssertTrue(string.isHTMLString())
        XCTAssertEqual(string.stripHTML(), "test")
        XCTAssertEqual(string.trimming("test"), "<p></p>")
        XCTAssertNotNil(string.htmlAttributedString())
    }
    
    func testHashLinkDetection() {
        let links = FTLinkDetection.getHashTagRanges(testString)
        XCTAssertEqual(links.count, 1)
        if let hash = links.first {
            XCTAssertTrue(hash.linkType == .hashTag)
            XCTAssertTrue(hash.linkURL.absoluteString == testHash)
        }
    }
    
    func testURLLinkDetection() {
        let links = FTLinkDetection.getURLLinkRanges(testString)
        XCTAssertEqual(links.count, 1)
        if let url = links.first {
            XCTAssertTrue(url.linkType == .url)
            XCTAssertTrue(url.linkURL.absoluteString.hasSuffix(testUrl))
        }
    }
    
    func testPerformanceURLLink() {
        // This is an example of a performance test case.
        self.measure {
            _ = FTLinkDetection.getURLLinkRanges(self.testString)
        }
    }
    
    func testPerformanceHashLink() {
        // This is an example of a performance test case.
        self.measure {
            _ = FTLinkDetection.getHashTagRanges(self.testString)
        }
    }
}
