//
//  FTUtils.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

//Operator Overloading
func += <Key, Value> ( left: inout [Key:Value], right: [Key:Value]){
    for (key, value) in right {
        left[key] = value
    }
}

//Loading Data from given Path
func contentAt(path: String) throws -> Any? {
    
    guard let content = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)) else {
        return nil
    }
    
    return try? JSONSerialization.jsonObject(with: content, options: .allowFragments)
}
