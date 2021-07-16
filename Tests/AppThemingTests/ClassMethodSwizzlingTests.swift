//
//  ClassMethodSwizzlingTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 10/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

import AppTheming
import CoreUtility
import XCTest

private final class TestSwizzling {
    @objc dynamic func getMessage() -> String { "getMessage" }
    @objc dynamic func swizzledMessage() -> String { "swizzledMessage" }
    
    // Swizzling out view's layoutSubviews property for Updating Visual theme
    static func swizzleTestMethod() {
        instanceMethodSwizzling(TestSwizzling.self, #selector(TestSwizzling.getMessage), #selector(TestSwizzling.swizzledMessage))
    }
}

final class ClassMethodSwizzlingTests: XCTestCase {
    
    func testMethodSwizzling() {
        let temp = TestSwizzling()
        XCTAssertNotNil(temp)
        XCTAssertEqual(temp.getMessage(), "getMessage")
        XCTAssertEqual(temp.swizzledMessage(), "swizzledMessage")
        TestSwizzling.swizzleTestMethod() // Swizzle method and test again
        XCTAssertEqual(temp.getMessage(), "swizzledMessage")
        XCTAssertEqual(temp.swizzledMessage(), "getMessage")
    }
}
