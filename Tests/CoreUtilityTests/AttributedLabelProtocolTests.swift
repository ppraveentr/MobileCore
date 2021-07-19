//
//  AttributedLabelProtocolTests.swift
//  CoreUtilityTests
//
//  Created by Praveen P on 18/7/21.
//  Copyright © 2021 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreUtility)
import CoreUtility
#endif
import XCTest

final class AttributedLabelProtocolTests: XCTestCase {
    
    func testDefaultText() {
        // let
        let label = UILabel(frame: .zero)
        // then
        XCTAssertFalse(label.isLinkUnderLineEnabled)
        XCTAssertTrue(label.islinkDetectionEnabled)
        XCTAssertNil(label.linkHandler)
    }
    
    func testHTMLText() {
        // let
        let label = UILabel(frame: .zero)
        label.isLinkUnderLineEnabled = true
        label.islinkDetectionEnabled = true
        label.text = "<p>Follow #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a></p>"
        label.linkHandler = { link in
            XCTAssertNotNil(link)
        }
        // when
        label.updateVisualThemes()
        // then
        XCTAssertTrue(label.isLinkUnderLineEnabled)
        XCTAssertTrue(label.islinkDetectionEnabled)
        XCTAssertNotNil(label.attributedText)
        XCTAssertNotNil(label.textContainer)
        XCTAssertNotNil(label.linkRanges)
        XCTAssertEqual(label.linkRanges?.count, 2)
        // When
        label.tapGestureRecognizer.state = .ended
    }
}
