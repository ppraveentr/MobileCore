//
//  NetworkMananger.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public class NetworkMananger {
    
    static let sharedInstance = NetworkMananger()

    // MARK: Configurations
    // MARK: Requst Paths
    public static var appBaseURL: String = "" {
        didSet {
            if !appBaseURL.hasSuffix("/") {
                appBaseURL.append("/")
            }
        }
    }

    // Check for stubData
    fileprivate static var isMockDataModel: Bool = false
    
    public static var isMockData: Bool {
        set {
            isMockDataModel = newValue
        }
        get {
            isMockDataModel && mockBundle != nil
        }
    }

    // Stub data bundle, used by ServiceClient
    static var mockBundle: Bundle?

    public static var mockBundleResource: URL? = nil {
        didSet {
            if mockBundleResource != nil {
                mockBundle = Bundle(url: mockBundleResource!)
            }
            else {
                mockBundle = nil
            }
        }
    }
    // MARK: Model Binding
    static var modelBindingPath: String = ""

    // TODO: To support multiple sources
    public static var serviceBindingPath: String = "" {
        didSet {
            try? NetworkMananger.loadModelSchema(fromPath: serviceBindingDirectory())
        }
    }

    // MARK: Rules Binding
    var serviceRuels = JSON()

    public static var serviceBindingRulesName: String = "" {
        didSet {
            try? NetworkMananger.loadBindingRules()
        }
    }

    // MARK: Model Schema
    var modelSchema = JSON()
    
    // MARK: Logger
    public static var enableConsoleLogging: Bool {
        set {
            Logger.enableConsoleLogging = newValue
        }
        get {
            Logger.enableConsoleLogging
        }
    }
    
    // MARK: Init with Relection
    init() {
        Reflection.registerModuleIdentifier(NetworkMananger.self)
    }
}

public extension NetworkMananger {

    // MARK: Session Headers
    static var httpAdditionalHeaders: [String: String]? {
        set {
            UserCacheManager.httpAdditionalHeaders = newValue
        }
        get {
            UserCacheManager.httpAdditionalHeaders
        }
    }
}

// MARK: Model Schema
extension NetworkMananger {

    static func serviceBindingDirectory() -> String {
        if let resourcePath = Bundle.main.resourceURL?.appendingPathComponent(self.serviceBindingPath) {
            return resourcePath.path
        }
        return ""
    }

    public static func loadModelSchema(_ data: [String: Any] ) throws {

        if JSONSerialization.isValidJSONObject(data) {
            self.sharedInstance.modelSchema += data
        }
    }

    public static func loadModelSchema(fromPath path: String? = nil) throws {

        let path = path ?? serviceBindingDirectory()
        try path.filesAtPath { filePath in
            do {
                if let content: JSON = try filePath.jsonContentAtPath() {
                    try loadModelSchema(content)
                }
                else {
                    ftLog("Files emtpy")
                }
            }
            catch {
                ftLog("Load Model Schema Error: ", error)
            }
        }
    }

    public static func schemaForClass(classKey: String) throws -> JSON? {
        self.sharedInstance.modelSchema[classKey] as? JSON
    }
}

// MARK: Binding Rules
extension NetworkMananger {

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
