//
//  FTMobileCoreTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import XCTest
@testable import FTMobileCore

class FTMobileCoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
//        try? FTModelConfig.loadModelSchema(["MDASample": ["identifier":"id"] ])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFTDataModel() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
            
//        let sample = FTDataModel.dataModelOfType("MDASample", withJSON: ["id":"sample"])
//        let sample = try? FTDataModel.init(dictionary: ["id":"sample"])
//        print(sample ?? "properties of type MDASample are empty");
    }
    
    func testFTModelBindType_Success() {
        let sample: FTModelBindType = FTModelBindType(rawValue: "String")!
        assert(sample == .String, "properties matches")
    }
    
    func testFTModelBindType_Failure() {
        let sample: FTModelBindType? = FTModelBindType(rawValue: "String22")
        assert(sample == nil, "properties is nil as excepted")
    }
}
