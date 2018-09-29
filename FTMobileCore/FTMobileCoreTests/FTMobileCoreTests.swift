//
//  FTMobileCoreTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import XCTest
@testable import FTMobileCore

class AccountDetail: FTServiceModel {
    var value: String = ""
    var name: String = ""
    init(value: String, name: String) {
        self.value = value
        self.name = name
    }
    
}

class Account: FTServiceModel {
    var name: String = ""
    var type: AccountDetail? = nil
    var data: [String] = []
    init(name: String, type: AccountDetail, data: [String]) {
        self.name = name
        self.type = type
        self.data = data
    }
    
}

class TestService: FTServiceClient {
    var serviceName: String = "TestService"
    var inputStack: Account?
    var responseStack: AccountDetail?

    required init(inputStack: FTServiceModel?) {
        self.inputStack = inputStack as? Account
    }
    
}

class FTMobileCoreTests: XCTestCase {

    override func setUp() {
        FTReflection.registerModuleIdentifier(Account.self)
    }

    func testFTServiceClient() {
        let account1De = AccountDetail(value: "Details_1", name: "name")
        TestService.make(modelStack: account1De) { (statuys) in
            dump(statuys)
        }
    }

    func testFTDataModel() {

        let account1De = AccountDetail(value: "Details_1", name: "name")
        var account1 = Account(name: "stsda", type: account1De, data: ["account1_adas","account1_fasda"])
        let account2De = AccountDetail(value: "Details_2", name: "name")
        let account2 = Account(name: "da", type: account2De, data: ["account2_adas","account2_fasda"])

        print("account1: ",account1.jsonString() ?? "")
         print("account2: ",account2.jsonString() ?? "")
        account1.merge(data: account2)
        print("merged_account1: ",account1.jsonString() ?? "")

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

        print(className ?? "class conversion nil")
        do {
            if let className = FTReflection.swiftClassTypeFromString("Account") {

                print(className.self)

                try FTServiceModel.makeModel(json: [
                    "value" : "Details_2",
                    "name" : "name"
                ])
            }
        }catch {
            print("Unexpected error: \(error).")
            assertionFailure("Error block dont match")
        }
    }

    func testModelDataCreation_Failure() {
        do {
            try FTServiceModel.makeModel(json: 23)
        }catch FTJsonParserError.invalidJSON {
            XCTAssert(true)
        }catch {
            print("Unexpected error: \(error).")
            assertionFailure("Error block dont match")
        }
    }
    
}
