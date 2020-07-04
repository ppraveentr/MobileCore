//
//  UserCacheManagerTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 07/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

final class UserCacheManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        _ = UserCacheManager.sharedInstance
    }
    
    override func tearDown() {
        super.tearDown()
        UserCacheManager.clearUserData()
    }
    
    func testSessionCache() {
        XCTAssertNotNil(UserCacheManager.sharedInstance)
        XCTAssertNotNil(UserCacheManager.userCache)
        
        let testData = ["Test": "testData"]
        UserCacheManager.httpAdditionalHeaders = testData
        XCTAssertNotNil(UserCacheManager.httpAdditionalHeaders)
        XCTAssertEqual(UserCacheManager.defaultSessionHeaders(), testData)
    }
    
    func testApplicationCache() {
        let testData = "testData"

        UserCacheManager.setCacheObject(testData as AnyObject, key: "test.key", cacheType: .application)

        let data = UserCacheManager.getCachedObject(key: "test.key", cacheType: .application)
        XCTAssertNotNil(data)
        
        let result = data as? String
        XCTAssertEqual(result, testData)
    }
    
    func testUserCache() {
        let testData = "testData"
        
        UserCacheManager.setCacheObject(testData as AnyObject, key: "test.key.user")
        UserCacheManager.setCacheObject(testData as AnyObject, forType: Self.self)

        let data = UserCacheManager.getCachedObject(key: "test.key.user")
        XCTAssertNotNil(data)
        XCTAssertEqual(data as? String, testData)

        let classTypeData = UserCacheManager.getCachedObject(forType: Self.self)
        XCTAssertNotNil(classTypeData)
        XCTAssertEqual(classTypeData as? String, testData)
    }
}
