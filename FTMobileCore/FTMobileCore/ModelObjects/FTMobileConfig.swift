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
    static public var appBaseURL: String = "" {
        didSet {
            if !appBaseURL.hasSuffix("/") {
                appBaseURL.append("/")
            }
        }
    }
    static var modelBindingPath: String = ""
    static public var serviceBindingPath: String = "" {
        didSet {
//            if let path = serviceBindingDirectory() {
                try? FTMobileConfig.loadModelSchema(fromPath: serviceBindingDirectory())
//            }
        }
    }
    static public func serviceBindingDirectory() -> String {
        if let resourcePath = Bundle.main.resourceURL?.appendingPathComponent(self.serviceBindingPath) {
            return resourcePath.path
        }
        return ""
    }
    
    //MARK:
    init() { FTReflection.registerModuleIdentifier(FTMobileConfig.self) }
    
    var modelSchema = JSON()
    
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
