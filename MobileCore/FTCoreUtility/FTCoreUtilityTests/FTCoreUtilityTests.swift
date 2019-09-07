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
            "sa": "sada",
            "sad": nil,
            "dasd": [
                "adsd": "dasd",
                "sd": nil
            ],
            "dasfdsd": ["asds", nil, "adasd"]
        ]
        dic.stripNilElements()
        XCTAssert(dic.count == 3)
    }
    
    func testMergeElements() {
        var dic1: [String : Any] = [
            "set1": "sada",
            "set2": [ "set1": "dasd" ]
            ]
        let dic2: [String : Any] = [
            "set2": [ "set2": "adasd" ],
            "set3": [ "val1", "val2" ]
            ]
        dic1.merge(another: dic2)
        XCTAssert(dic1.count == 3)
    }
}
