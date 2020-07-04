//
//  CoreUtilityTests.swift
//  MobileCoreUtilityTests
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

final class CoreUtilityTests: XCTestCase {
    
    func testStrippingNilElements() {
        var dic: [String: Any?] = [
            "set": "val",
            "set1": nil,
            "sert2": [
                "set21": "val",
                "sert22": nil
            ],
            "set3": ["val1", nil, "value2"]
        ]
        dic.stripNilElements()
        XCTAssert(dic.count == 3)
    }
    
    func testMergeElements() {
        var dic1: [String : Any] = [ "set1": "sada", "set2": [ "set1": "val1" ] ]
        let dic2: [String : Any] = [ "set2": [ "set2": "val2" ], "set3": [ "val4", "val4" ] ]
        dic1.merge(another: dic2)
        XCTAssert(dic1.count == 3)
    }
    
    func testCeil() {
        let ceilSize = CGSize(width: 100.3, height: 100.7)
        XCTAssertEqual(ceil(size: ceilSize), CGSize(width: 101.0, height: 101.0))

        let largeSize = CGSize(width: 100, height: 100)
        let smallSize = CGSize(width: 50, height: 150)
        XCTAssertEqual(maxSize(largeSize, smallSize), CGSize(width: 100, height: 150))
    }
    
    func testJSONData() {
        let testData = [ "set1": "val1", "set2": "val2" ]
        let data = try? JSONSerialization.data(withJSONObject: testData, options: .prettyPrinted)
        XCTAssertNotNil(data)
        let res = try? data?.jsonContent() as? [String:String]
        XCTAssertNotNil(res)
        XCTAssertEqual(res, testData)
    }
    
    func testStringDecoding() {
        let testData = "set1"
        let data = testData.data(using: .utf32)
        XCTAssertNotNil(data)
        let res = data?.decodeToString(encodingList: [.utf32])
        XCTAssertNotNil(res)
        XCTAssertEqual(res, testData)
    }
    
    // MARK: isRegisteredURLScheme
    func testRegisteredURLScheme() {
        XCTAssertFalse(BundleURLScheme.isRegisteredURLScheme(scheme: ""))
        XCTAssertTrue(BundleURLScheme.isRegisteredURLScheme(scheme: "one"))
    }
}
