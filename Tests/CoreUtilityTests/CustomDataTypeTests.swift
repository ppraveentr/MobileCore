//
//  CustomDataTypeTests.swift
//  CoreUtilityTests
//
//  Created by Praveen P on 07/09/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreUtility)
import CoreUtility
#endif
import XCTest

final class CustomDataTypeTests: XCTestCase {
    
    private let testString = "Follow @ppraveentr or #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a>"
    private let testUrl = "www.W3Schools.com"
    private let testHash = "#visit"

    // MARK: String
    func testNilorEmpty() {
        var string: String?
        XCTAssertTrue(string.isNilOrEmpty)
        XCTAssertFalse("test".isHTMLString)
        string = "random"
        XCTAssertFalse(string.isNilOrEmpty)
        XCTAssertFalse(string.isHTMLString)
    }
    
    func testHTMLString() {
        let string = "<p>test</p>"
        XCTAssertTrue(string.isHTMLString)
        XCTAssertEqual(string.stripHTML(), "test")
        XCTAssertEqual(string.trimming("test"), "<p></p>")
        // XCTAssertNotNil(string.htmlAttributedString())
    }
    
    func testHashLinkDetection() {
        let links = LinkHandlerModel.getHashTagRanges(testString)
        XCTAssertEqual(links.count, 1)
        if let hash = links.first {
            XCTAssertTrue(hash.linkType == .hashTag)
            XCTAssertTrue(hash.linkURL.absoluteString == testHash)
        }
    }
    
    func testURLLinkDetection() {
        let links = LinkHandlerModel.getURLLinkRanges(testString)
        XCTAssertEqual(links.count, 1)
        if let url = links.first {
            XCTAssertTrue(url.linkType == .url)
            XCTAssertTrue(url.linkURL.absoluteString.hasSuffix(testUrl))
        }
    }
    
    func testPerformanceURLLink() {
        // This is an example of a performance test case.
        self.measure {
            _ = LinkHandlerModel.getURLLinkRanges(self.testString)
        }
    }
    
    func testPerformanceHashLink() {
        // This is an example of a performance test case.
        self.measure {
            _ = LinkHandlerModel.getHashTagRanges(self.testString)
        }
    }
}
