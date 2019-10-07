//
//  FTServiceModelTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

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
    var type: AccountDetail?
    var data: [String] = []
    
    init(name: String, type: AccountDetail, data: [String]) {
        self.name = name
        self.type = type
        self.data = data
    }
}

final class TestService: FTServiceClient {
    
    var serviceName: String = "TestService"
    var request: FTReqeustType = .POST
    var inputStack: Account?
    var responseStack: AccountDetail?
    var responseStackType: Any?

    required init(inputStack: FTServiceModel?) {
        self.inputStack = inputStack as? Account
    }
}

class FTServiceModelTests: XCTestCase {

    var testService: TestService?
    override func setUp() {
        FTReflection.registerModuleIdentifier(Account.self)
        
        let accountDe = AccountDetail(value: "Details_1", name: "name")
        let account = Account(name: "stsda", type: accountDe, data: ["account1_adas", "account1_fasda"])
        testService = TestService(inputStack: account)
    }

    func testFTDataModel() {
        let account1De = AccountDetail(value: "Details_1", name: "name")
        var account1 = Account(name: "stsda", type: account1De, data: ["account1_adas", "account1_fasda"])
        let account2De = AccountDetail(value: "Details_2", name: "name")
        let account2 = Account(name: "da", type: account2De, data: ["account2_adas", "account2_fasda"])

        account1.merge(data: account2)
        XCTAssert(account1.type?.value == "Details_2")
    }

    func testFTModelBindTypeSuccess() {
        let sample = FTModelBindType(rawValue: "String")
        XCTAssert(sample == .string)
    }

    func testFTModelBindTypeFailure() {
        let sample: FTModelBindType? = FTModelBindType(rawValue: "String22")
        XCTAssertNil(sample)
    }

    func testModelDataCreationFromString() {
        XCTAssertNotNil(FTReflection.swiftClassTypeFromString("AccountDetail"))
        let accountModel = try? AccountDetail.makeModel(json: [ "value": "Details_2", "name": "name"])
        XCTAssertNotNil(accountModel)
        XCTAssert(accountModel?.name == "name")
        XCTAssert(accountModel?.value == "Details_2")
    }

    func testModelDataCreationFailure() {
        let model = try? AccountDetail.makeModel(json: [ "1": "1", "2": "2"])
        XCTAssertNil(model)
    }
    
    func testReqeust() {
        XCTAssertEqual(testService?.request.stringValue(), "POST")
        let body = testService?.request.requestBody(model: testService?.inputStack)
        XCTAssertNotNil(body)
        
        let formRequest: FTReqeustType = .FORM
        let formBody = formRequest.requestBody(model: testService?.inputStack)
        XCTAssertNotNil(formBody)
    }
}
