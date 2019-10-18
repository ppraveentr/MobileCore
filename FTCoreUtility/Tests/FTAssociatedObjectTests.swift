//
//  FTAssociatedObjectTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen P on 17/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

class FTAssociatedObjectTests: XCTestCase {
    
    func testGenericSetAssociated() {
        //Given
        let value: String = "TestAssociated"
        FTAssociatedObject<String>.setAssociated(self, value: value)
        //Then
        let retrunValue = FTAssociatedObject<String>.getAssociated(self)
        XCTAssertEqual(value, retrunValue)
        
        // When
        FTAssociatedObject<String>.resetAssociated(self)
        // Then
        let emptyValue1 = FTAssociatedObject<String>.getAssociated(self)
        XCTAssertNil(emptyValue1)
        
        //Given
        FTAssociatedObject<String>.setAssociated(self, value: value)
        // When
        FTAssociatedObject<String>.resetAssociated(self, key: &FTAssociatedKey.DefaultKey)
        // Then
        let emptyValue2 = FTAssociatedObject<String>.getAssociated(self)
        XCTAssertNil(emptyValue2)
    }
}
