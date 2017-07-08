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
        
        try? FTModelConfig.loadModelSchema(["MDASample": ["identifier":"id"] ])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let bundle = Bundle(identifier: "com.company.bundle.LiveUI")
        
        var sample = FTModelObject.createDataModelOfType("MDASample", fromDictionary: ["id":"sample"])

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
