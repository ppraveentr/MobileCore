//
//  FTMobileCoreSampleTests.swift
//  FTMobileCoreSampleTests
//
//  Created by Praveen Prabhakar on 08/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import XCTest
@testable import FTMobileCore
@testable import FTMobileCoreSample

class FTMobileCoreSampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        try? FTModelConfig.loadModelSchema(["MDASample": ["id":"identifier"] ])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMDASample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
//        let sample: MDASample = FTDataModel.dataModelOfType("MDASample", withJSON: ["id":"sample"]) as! MDASample
//        sample.amount = 34.3
        
    }
    
}
