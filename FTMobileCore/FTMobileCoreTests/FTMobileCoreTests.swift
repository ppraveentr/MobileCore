//
//  FTMobileCoreTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import XCTest
@testable import FTMobileCore

struct AccountDetail: FTModelData {
    var value: String = ""
    var name: String = ""
}

struct Account: FTModelData {
    var name: String = ""
    var type: AccountDetail? = nil
    var data: [String] = []
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

        var account1De = AccountDetail(value: "Details_1", name: "name")
        var account1 = Account(name: "stsda", type: account1De, data: ["adas","fasda"])
        var account2De = AccountDetail(value: "Details_2", name: "name")
        let account2 = Account(name: "da", type: account2De, data: ["adas","fasda"])

        print(account1.jsonString())
        account1.merge(data: account2)
        print(account1.jsonString())

        assert(account1.type?.value == "Details_2", "FTDataModel data merging failed")
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
