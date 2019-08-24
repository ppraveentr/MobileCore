//
//  FTStringUtilityTests.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 16/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

class FTStringUtilityTests: XCTestCase {
    
    let testString = "Follow @krelborn or #visit <a href=\"https://www.w3schools.com\">Visit W3Schools</a>"
    
    func testURLLinkDetection() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
       let links = FTLinkDetection.getURLLinkRanges(testString)
        
        links.forEach {
            FTLog("\n" + $0.description + "\n")
        }
    }
    
    func testHashLinkDetection() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let links = FTLinkDetection.getHashTagRanges(testString)
        
        links.forEach {
            FTLog("\n" + $0.description + "\n")
        }
    }
    
    func testPerformanceURLLink() {
        // This is an example of a performance test case.
        self.measure {
            _ = FTLinkDetection.getURLLinkRanges(self.testString)
        }
    }
    
    func testPerformanceHashLink() {
        // This is an example of a performance test case.
        self.measure {
            _ = FTLinkDetection.getHashTagRanges(self.testString)
        }
    }
}
