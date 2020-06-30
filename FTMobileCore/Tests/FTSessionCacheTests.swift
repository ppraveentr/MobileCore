//
//  FTSessionCacheTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen P on 07/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

final class FTSessionCacheTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        _ = FTUserCache.sharedInstance
    }
    
    override func tearDown() {
        super.tearDown()
        FTUserCache.clearUserData()
    }
    
    func testSessionCache() {
        XCTAssertNotNil(FTUserCache.sharedInstance)
        XCTAssertNotNil(FTUserCache.userCache)
        
        let testData = ["Test": "testData"]
        FTUserCache.httpAdditionalHeaders = testData
        XCTAssertNotNil(FTUserCache.httpAdditionalHeaders)
        XCTAssertEqual(FTUserCache.defaultSessionHeaders(), testData)
    }
    
    func testApplicationCache() {
        let testData = "testData"

        FTUserCache.setCacheObject(testData as AnyObject, key: "test.key", cacheType: .application)

        let data = FTUserCache.getCachedObject(key: "test.key", cacheType: .application)
        XCTAssertNotNil(data)
        
        let result = data as? String
        XCTAssertEqual(result, testData)
    }
    
    func testUserCache() {
        let testData = "testData"
        
        FTUserCache.setCacheObject(testData as AnyObject, key: "test.key.user")
        FTUserCache.setCacheObject(testData as AnyObject, forType: FTSessionCacheTests.self)

        let data = FTUserCache.getCachedObject(key: "test.key.user")
        XCTAssertNotNil(data)
        XCTAssertEqual(data as? String, testData)

        let classTypeData = FTUserCache.getCachedObject(forType: FTSessionCacheTests.self)
        XCTAssertNotNil(classTypeData)
        XCTAssertEqual(classTypeData as? String, testData)
    }
}
