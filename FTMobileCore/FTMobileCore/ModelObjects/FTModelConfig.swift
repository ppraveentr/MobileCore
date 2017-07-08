//
//  FTModelConfig.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public class FTModelConfig {
    
    static let sharedInstance  = FTModelConfig()
    
    var modelSchema = JSON()
    
    public class func loadModelSchema(_ data: [String : Any] ) throws {
        
        if JSONSerialization.isValidJSONObject(data) {
            sharedInstance.modelSchema += data
        }
    }
    
    public class func loadModelSchema(fromPath path: String ) throws {
        
        if let content = try? contentAt(path: path) as! [String : Any]  {
            try? loadModelSchema(content)
        }
    }
}
