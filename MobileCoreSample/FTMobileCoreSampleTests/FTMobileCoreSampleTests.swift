//
//  FTMobileCoreSampleTests.swift
//  FTMobileCoreSampleTests
//
//  Created by Praveen Prabhakar on 08/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

@testable import FTMobileCoreSample
import XCTest

class FTMobileCoreSampleTests: XCTestCase {
    
    var model: MDASample = MDASample()
    let amount: Decimal = 34.33
    
    override func setUp() {
        super.setUp()
        model.amount = amount
    }
    
    func testJsonModel() {
        let jsonModel = model.jsonModel()
        let modelAmount = jsonModel?["amount.usd"] as? Decimal
        XCTAssert(amount == modelAmount)
    }
    
    func testJsonString() {
        let jsonString = model.jsonString()
        XCTAssert(jsonString == "{\n  \"amount.usd\" : 34.32999999999999488\n}")
    }
}
