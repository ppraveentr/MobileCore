//
//  FTCoreUtilityTests.swift
//  FTCoreUtilityTests
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import XCTest
@testable import MobileCore

class FTCoreUtilityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testClassName() {
        
//        FTLog(UIView.fromNib()!)
        
//        FTLog("class name", get_classNameAsString(obj: self))
    }
    
    func testStrippingNilElements() {
        
        var dic: [String: Any?] = [
            "sa":"sada",
            "sad": nil,
            "dasd": [
                "adsd":"dasd",
                "sd":nil
            ],
            "dasfdsd": ["asds", nil, "adasd"]
        ]
        dic.stripNilElements()
        FTLog("\n \(dic) \n")
    }
}
