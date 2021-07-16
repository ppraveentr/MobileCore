//
//  NetworkManangerTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 12/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

#if canImport(NetworkLayer)
@testable import CoreComponents
@testable import CoreUtility
@testable import NetworkLayer
#endif
import XCTest

final class NetworkManangerTests: XCTestCase {
    
    private let config = NetworkMananger.sharedInstance

    // MARK: Service URL
    private let kEndpointURL = "EndpointURL/"
    private let kServiceBindingsName = "Bindings/ServiceBindings"
    private let kServiceBindingRulesName = "NovelServiceRules.plist"
    // MARK: Mock
    private let kMockServerURL = "http://127.0.0.1:3000/"
    private let kMockBundleResource = NetworkLayerTestsUtility.kMobileCoreBundle.bundleURL
    private let kMockDataEnabled = true
    private let httpAdditionalHeaders = ["Test": "TestValue"]
    
    // MARK: Model Binding
    func configureAppBase() {
        NetworkMananger.isMockData = false

        // Service Binding
        NetworkMananger.serviceBindingPath = kServiceBindingsName
        NetworkMananger.serviceBindingRulesName = kServiceBindingRulesName
        // App Config
        NetworkMananger.appBaseURL = kEndpointURL
        
        NetworkMananger.httpAdditionalHeaders = httpAdditionalHeaders
    }
    
    func configDebug() {
        Logger.enableConsoleLogging = true
        NetworkMananger.appBaseURL = kMockServerURL
        NetworkMananger.mockBundleResource = kMockBundleResource
        NetworkMananger.isMockData = kMockDataEnabled
    }
    
    func testDefaultConfigValues() {
        XCTAssertNotNil(config)
        
        self.configureAppBase()
        XCTAssertEqual(NetworkMananger.appBaseURL, kEndpointURL)
        XCTAssertEqual(NetworkMananger.serviceBindingPath, kServiceBindingsName)
        XCTAssertEqual(NetworkMananger.httpAdditionalHeaders, httpAdditionalHeaders)
    }
    
    func testDebugConfigValues() {
        self.configDebug()
        XCTAssertEqual(NetworkMananger.isMockData, kMockDataEnabled)
        XCTAssertEqual(NetworkMananger.appBaseURL, kMockServerURL)
        XCTAssertEqual(NetworkMananger.mockBundleResource, kMockBundleResource)
    }
}
