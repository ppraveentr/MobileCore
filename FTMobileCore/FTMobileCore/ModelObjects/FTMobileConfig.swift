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

    //MARK: Configurations
    //MARK: Requst Paths
    static public var appBaseURL: String = "" {
        didSet {
            if !appBaseURL.hasSuffix("/") {
                appBaseURL.append("/")
            }
        }
    }
    static public var mockURL: String = "" {
        didSet {
            if !appBaseURL.hasSuffix("/") {
                appBaseURL.append("/")
            }
        }
    }
    static public var isMockData: Bool = false

    //MARK: Model Binding
    static var modelBindingPath: String = ""
    static public var serviceBindingPath: String = "" {
        didSet {
            try? FTMobileConfig.loadModelSchema(fromPath: serviceBindingDirectory())
        }
    }

    //MARK: Rules Binding
     var serviceRuels = JSON()
    static public var serviceBindingRulesName: String = "" {
        didSet {
            try? FTMobileConfig.loadBindingRules()
        }
    }

    //MARK: Model Schema
    var modelSchema = JSON()
    
    //MARK: Init with Relection
    init() { FTReflection.registerModuleIdentifier(FTMobileConfig.self) }
}

//MARK: Model Schema
extension FTMobileConfig {

    static func serviceBindingDirectory() -> String {
        if let resourcePath = Bundle.main.resourceURL?.appendingPathComponent(self.serviceBindingPath) {
            return resourcePath.path
        }
        return ""
    }

    public class func loadModelSchema(_ data: [String : Any] ) throws {

        if JSONSerialization.isValidJSONObject(data) {
            self.sharedInstance.modelSchema += data
        }
    }

    public class func loadModelSchema(fromPath path: String ) throws {

        let path = serviceBindingDirectory()
        try path.filesAtPath({ (filePath) in
            do {
                if let content: JSON = try filePath.jsonContentAtPath() {
                    try? loadModelSchema(content)
                }
            } catch {}
        })
    }

    public class func schemaForClass(classKey: String) throws -> JSON? {
        return self.sharedInstance.modelSchema[classKey] as? JSON
    }
}

//MARK: Binding Rules
extension FTMobileConfig {

    public class func loadBindingRules() throws {

        if
            let resourcePath = Bundle.main.path(forResource: self.serviceBindingRulesName, ofType: nil),
            let content: JSON = NSMutableDictionary(contentsOfFile: resourcePath) as? JSON {
            if JSONSerialization.isValidJSONObject(content) {
                self.sharedInstance.serviceRuels += content
            }
        }
    }
}
