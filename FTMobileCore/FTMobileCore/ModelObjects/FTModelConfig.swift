//
//  FTModelConfig.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

//typealias
public typealias JSON = Dictionary<String, Any>

//Operator Overloading
func += <K,V> ( left: inout [K:V], right: [K:V]){
    for (k, v) in right {
        left[k] = v
    }
}

public class FTModelConfig {
    
    static let sharedInstance = FTModelConfig()
    
    init() { FTReflection.registerBundleIdentifier(FTModelConfig.self) }
    
    var modelSchema = JSON()
    
    public class func loadModelSchema(_ data: [String : Any] ) throws {
        
        if JSONSerialization.isValidJSONObject(data) {
            self.sharedInstance.modelSchema += data
        }
    }
    
    public class func loadModelSchema(fromPath path: String ) throws {
        
        if let content = try path.JSONContentAtPath() as? JSON {
            try? loadModelSchema(content)
        }
    }
    
    public class func schemaForClass(classKey: String) throws -> JSON? {
        
        //TODO: throws
//        if let data = self.sharedInstance.modelSchema[classKey] {
//            return data
//        }
        
        return self.sharedInstance.modelSchema[classKey] as? JSON
    }
}
