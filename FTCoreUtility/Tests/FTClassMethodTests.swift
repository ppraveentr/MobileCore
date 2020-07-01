//
//  FTClassMethodTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 10/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

final class FTClassMethodTests: XCTestCase {
    
    func testMethodSwizzling() {
        let temp = TestSwizzling()
        XCTAssertNotNil(temp)
        XCTAssertEqual(temp.getMessage(), "getMessage")
        XCTAssertEqual(temp.swizzledMessage(), "swizzledMessage")
        TestSwizzling.swizzleTestMethod() //Swizzle method and test again
        XCTAssertEqual(temp.getMessage(), "swizzledMessage")
        XCTAssertEqual(temp.swizzledMessage(), "getMessage")
    }
}
