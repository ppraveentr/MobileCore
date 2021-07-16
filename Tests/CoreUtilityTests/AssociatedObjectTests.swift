//
//  AssociatedObjectTests.swift
//  CoreUtilityTests
//
//  Created by Praveen P on 17/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

import CoreUtility
import XCTest

final class AssociatedObjectTests: XCTestCase {
    
    func testGenericSetAssociated() {
        // Given
        let value: String = "TestAssociated"
        AssociatedObject<String>.setAssociated(self, value: value)
        // Then
        let retrunValue = AssociatedObject<String>.getAssociated(self)
        XCTAssertEqual(value, retrunValue)
        
        // When
        AssociatedObject<String>.resetAssociated(self)
        // Then
        let emptyValue1 = AssociatedObject<String>.getAssociated(self)
        XCTAssertNil(emptyValue1)
        
        // Given
        AssociatedObject<String>.setAssociated(self, value: value)
        // When
        AssociatedObject<String>.resetAssociated(self, key: &AssociatedKey.defaultKey)
        // Then
        let emptyValue2 = AssociatedObject<String>.getAssociated(self)
        XCTAssertNil(emptyValue2)
    }
}
