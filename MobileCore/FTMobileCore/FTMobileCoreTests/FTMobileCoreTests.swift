//
//  FTMobileCoreTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import XCTest
@testable import MobileCore

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

final class TestService: FTServiceClient {
    
    var serviceName: String = "TestService"
    var inputStack: Account?
    var responseStack: AccountDetail?
    var responseStackType: Any?

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
            FTLog(statuys)
        }
    }

    func testFTDataModel() {

        let account1De = AccountDetail(value: "Details_1", name: "name")
        var account1 = Account(name: "stsda", type: account1De, data: ["account1_adas","account1_fasda"])
        let account2De = AccountDetail(value: "Details_2", name: "name")
        let account2 = Account(name: "da", type: account2De, data: ["account2_adas","account2_fasda"])

        FTLog("account1: ",account1.jsonString() ?? "")
         FTLog("account2: ",account2.jsonString() ?? "")
        account1.merge(data: account2)
        FTLog("merged_account1: ",account1.jsonString() ?? "")

        XCTAssert(account1.type?.value == "Details_2", "FTDataModel data merging failed")
    }

    func testFTModelBindType_Success() {
        let sample: FTModelBindType = FTModelBindType(rawValue: "String")!
        XCTAssert(sample == .String, "properties matches")
    }

    func testFTModelBindType_Failure() {
        let sample: FTModelBindType? = FTModelBindType(rawValue: "String22")
        XCTAssert(sample == nil, "properties is nil as excepted")
    }

    func testModelDataCreation_FromString() {
        guard (FTReflection.swiftClassTypeFromString("AccountDetail") != nil) else {
            XCTAssert(false, "class conversion nil")
            return
        }

        do {
            let accountModel = try AccountDetail.makeModel(json: [ "value" : "Details_2", "name" : "name"])
            XCTAssert(accountModel.name == "name", "")
            XCTAssert(accountModel.value == "Details_2", "")
        }catch {
            FTLog("Unexpected error: \(error).")
            XCTAssert(false, "Account model creation failure")
        }
    }

    func testModelDataCreation_Failure() {
        do {
           _ = try AccountDetail.makeModel(json: [ "values" : "Details_2", "names" : "name"])
        }
        catch FTJsonParserError.invalidJSON {
            XCTAssert(true)
        }
        catch {
            FTLog("Unexpected error: \(error).")
            XCTAssert(true, "Account model creation failure")
        }
    }
}
