//
//  FTMobileCoreTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import XCTest
@testable import FTMobileCore

struct Account: FTModelData {
    var name: String = ""
}

class FTMobileCoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
//        try? FTMobileConfig.loadModelSchema(["MDASample": ["identifier":"id"] ])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFTDataModel() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
            
//        let sample = FTModelD.dataModelOfType("MDASample", withJSON: ["id":"sample"])
//        let sample = try? FTModelD.init(dictionary: ["id":"sample"])
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
    
    func testModelDataCreation_FromString() {
        let className = FTReflection.swiftClassTypeFromString("Account")
        
        print(className)
//        do {
//            if let className = FTReflection.swiftClassTypeFromString("Account") as? FTModelData {
//                try FTModelObject.createDataModel(ofType: className().self, fromJSON: 23)
//            }
//        }catch {
//            print("Unexpected error: \(error).")
//            assertionFailure("Error block dont match")
//        }
    }
    
    func testModelDataCreation_Failure() {
        do {
            try FTModelObject.createDataModel(ofType: Account.self, fromJSON: 23)
        }catch FTJsonParserError.invalidJSON {
            XCTAssert(true)
        }catch {
            print("Unexpected error: \(error).")
            assertionFailure("Error block dont match")
        }
    }
}
