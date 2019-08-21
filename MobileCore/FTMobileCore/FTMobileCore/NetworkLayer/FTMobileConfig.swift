//
//  FTMobileConfig.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public class FTMobileConfig {
    
    static let sharedInstance = FTMobileConfig()

    // MARK: Configurations
    // MARK: Requst Paths
    static public var appBaseURL: String = "" {
        didSet {
            if !appBaseURL.hasSuffix("/") {
                appBaseURL.append("/")
            }
        }
    }

    // Check for stubData
    static fileprivate var isMockDataModel: Bool = false
    
    static public var isMockData: Bool {
        set {
            isMockDataModel = newValue
        }
        get {
            return isMockDataModel && mockBundle != nil
        }
    }

    // Stub data bundle, used by FTServiceClient
    static var mockBundle: Bundle? = nil

    static public var mockBundleResource: URL? = nil {
        didSet {
            if mockBundleResource != nil {
                mockBundle = Bundle(url: mockBundleResource!)
            } else {
                mockBundle = nil
            }
        }
    }
    // MARK: Model Binding
    static var modelBindingPath: String = ""

    // TODO: To support multiple sources
    static public var serviceBindingPath: String = "" {
        didSet {
            try? FTMobileConfig.loadModelSchema(fromPath: serviceBindingDirectory())
        }
    }

    // MARK: Rules Binding
    var serviceRuels = JSON()

    static public var serviceBindingRulesName: String = "" {
        didSet {
            try? FTMobileConfig.loadBindingRules()
        }
    }

    // MARK: Model Schema
    var modelSchema = JSON()
    
    // MARK: Init with Relection
    init() {
        FTReflection.registerModuleIdentifier(FTMobileConfig.self)
    }
    
}

public extension FTMobileConfig {

    // MARK: Session Headers
    static var httpAdditionalHeaders: [String:String]? {
        set {
            FTUserCache.httpAdditionalHeaders = newValue
        }
        get {
            return FTUserCache.httpAdditionalHeaders
        }
    }

}

// MARK: Model Schema
extension FTMobileConfig {

    static func serviceBindingDirectory() -> String {
        if let resourcePath = Bundle.main.resourceURL?.appendingPathComponent(self.serviceBindingPath) {
            return resourcePath.path
        }
        return ""
    }

    public static func loadModelSchema(_ data: [String : Any] ) throws {

        if JSONSerialization.isValidJSONObject(data) {
            self.sharedInstance.modelSchema += data
        }
    }

    public static func loadModelSchema(fromPath path: String? = nil) throws {

        let path = path ?? serviceBindingDirectory()
        try path.filesAtPath { (filePath) in
            do {
                if let content: JSON = try filePath.jsonContentAtPath() {
                    try loadModelSchema(content)
                } else {
                    FTLog("Files emtpy")
                }
            } catch {
                FTLog("Load Model Schema Error: ", error)
            }
        }
    }

    public static func schemaForClass(classKey: String) throws -> JSON? {
        return self.sharedInstance.modelSchema[classKey] as? JSON
    }
}

// MARK: Binding Rules
extension FTMobileConfig {

    public static func loadBindingRules() throws {
        if
            let resourcePath = Bundle.main.path(forResource: self.serviceBindingRulesName, ofType: nil),
            let content: JSON = NSMutableDictionary(contentsOfFile: resourcePath) as? JSON,
            JSONSerialization.isValidJSONObject(content)
        {
                self.sharedInstance.serviceRuels += content
        }
    }
}
