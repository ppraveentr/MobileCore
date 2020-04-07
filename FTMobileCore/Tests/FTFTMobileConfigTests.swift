//
//  FTFTMobileConfigTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen P on 12/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
@testable import MobileCoreExample
import XCTest

class FTFTMobileConfigTests: XCTestCase {
    
    let config = FTMobileConfig.sharedInstance

    // MARK: Service URL
    let kEndpointURL = "EndpointURL/"
    let kServiceBindingsName = "Bindings/ServiceBindings"
    let kServiceBindingRulesName = "NovelServiceRules.plist"
    // MARK: Mock
    let kMockServerURL = "http://127.0.0.1:3000/"
    let kMockBundleResource = kFTMobileCoreBundle?.bundleURL
    let kMockDataEnabled = true
    let httpAdditionalHeaders = ["Test": "TestValue"]
    
    // MARK: Model Binding
    func configureAppBase() {
        FTMobileConfig.isMockData = false

        // Service Binding
        FTMobileConfig.serviceBindingPath = kServiceBindingsName
        FTMobileConfig.serviceBindingRulesName = kServiceBindingRulesName
        // App Config
        FTMobileConfig.appBaseURL = kEndpointURL
        
        FTMobileConfig.httpAdditionalHeaders = httpAdditionalHeaders
    }
    
    func configDebug() {
        FTLogger.enableConsoleLogging = true
        FTMobileConfig.appBaseURL = kMockServerURL
        FTMobileConfig.mockBundleResource = kMockBundleResource
        FTMobileConfig.isMockData = kMockDataEnabled
    }
    
    func testDefaultConfigValues() {
        XCTAssertNotNil(config)
        
        self.configureAppBase()
        XCTAssertEqual(FTMobileConfig.appBaseURL, kEndpointURL)
        XCTAssertEqual(FTMobileConfig.serviceBindingPath, kServiceBindingsName)
        XCTAssertEqual(FTMobileConfig.httpAdditionalHeaders, httpAdditionalHeaders)
    }
    
    func testDebugConfigValues() {
        self.configDebug()
        XCTAssertEqual(FTMobileConfig.isMockData, kMockDataEnabled)
        XCTAssertEqual(FTMobileConfig.appBaseURL, kMockServerURL)
        XCTAssertEqual(FTMobileConfig.mockBundleResource, kMockBundleResource)
    }
}
