//
//  FTCoreUtilityTests.swift
//  FTCoreUtilityTests
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

class FTCoreUtilityTests: XCTestCase {
    
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
        var dic1: [String : Any] = [
            "set1": "sada",
            "set2": [ "set1": "val1" ]
            ]
        let dic2: [String : Any] = [
            "set2": [ "set2": "val2" ],
            "set3": [ "val4", "val4" ]
            ]
        dic1.merge(another: dic2)
        XCTAssert(dic1.count == 3)
    }
    
    func testCeil() {
        let ceil_size = CGSize(width: 100.3, height: 100.7)
        XCTAssertEqual(ceil(size: ceil_size), CGSize(width: 101.0, height: 101.0))

        let large_size = CGSize(width: 100, height: 100)
        let small_size = CGSize(width: 50, height: 150)
        XCTAssertEqual(maxSize(large_size, small_size), CGSize(width: 100, height: 150))
    }
}
