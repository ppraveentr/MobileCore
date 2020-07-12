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
    
    override func tearDown() {
        super.tearDown()
        UserCacheManager.clearUserData()
    }
    
    func testSessionCache() {
        XCTAssertNotNil(UserCacheManager.sharedInstance)
        UserCacheManager.sharedInstance.setupUserSession()
        XCTAssertNotNil(UserCacheManager.sharedInstance.userCache)
        
        let testData = ["Test": "testData"]
        UserCacheManager.httpAdditionalHeaders = testData
        XCTAssertNotNil(UserCacheManager.httpAdditionalHeaders)
        XCTAssertEqual(UserCacheManager.httpAdditionalHeaders, testData)
    }
    
    func testApplicationCache() {
        // let
        let testData = "testData"
        // when
        UserCacheManager.setCacheObject(testData as AnyObject, key: "test.key", cacheType: .application)
        // then
        let data = UserCacheManager.getCachedObject(key: "test.key", cacheType: .application)
        XCTAssertNotNil(data)
        let result = data as? String
        XCTAssertEqual(result, testData)
    }
    
    func testUserCache() {
        // let
        let testData = "testData"
        UserCacheManager.sharedInstance.setupUserSession()
        // when
        UserCacheManager.setCacheObject(testData as AnyObject, key: "test.key.user")
        UserCacheManager.setCacheObject(testData as AnyObject, forType: Self.self)
        // then
        let data = UserCacheManager.getCachedObject(key: "test.key.user")
        XCTAssertNotNil(data)
        XCTAssertEqual(data as? String, testData)

        let classTypeData = UserCacheManager.getCachedObject(forType: Self.self)
        XCTAssertNotNil(classTypeData)
        XCTAssertEqual(classTypeData as? String, testData)
    }
}
