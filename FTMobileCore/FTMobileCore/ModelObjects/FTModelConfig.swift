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
    
    var modelSchema = [String : AnyObject]()
    
    public class func loadModelSchema(withDictionary data: [String : AnyObject] ) throws {
        
        if JSONSerialization.isValidJSONObject(data) {
            sharedInstance.modelSchema += data
        }
    }
    
    public class func loadModelSchema(fromPath path: String ) throws {
        
        if let content = try? contentAt(path: path) as! [String : AnyObject]  {
            if JSONSerialization.isValidJSONObject(content) {
                sharedInstance.modelSchema += content
            }
        }
    }
}
