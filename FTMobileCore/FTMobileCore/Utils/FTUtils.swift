//
//  FTUtils.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

//Operator Overloading
func += <K,V> ( left: inout [K:V], right: [K:V]){
    for (k, v) in right {
        left[k] = v
    }
}

//Loading Data from given Path
func contentAt(path: String) throws -> Any? {
    
    guard let content = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)) else {
        return nil
    }
    
    return try? JSONSerialization.jsonObject(with: content, options: .allowFragments)
}

//String Extention
extension String {
    
    func getClassInstance () -> AnyClass? {
        
        /// get namespace
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
        
        /// get 'anyClass' with classname and namespace
        let cls: AnyClass? = NSClassFromString("\(namespace).\(self)");
        
        // return AnyClass!
        return cls;
    }
}

extension NSObject {
    
    //
    // Retrieves an array of property names found on the current object
    // using Objective-C runtime functions for introspection:
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
    //
    func propertyNames() -> Array<String> {
        var results: Array<String> = [];
        
        // retrieve the properties via the class_copyPropertyList function
        var count: UInt32 = 0;
        let myClass: AnyClass = self.classForCoder;
        let properties = class_copyPropertyList(myClass, &count);
        
        // iterate each objc_property_t struct
        for i: UInt32 in 0 ..< count {
            let property = properties?[Int(i)];
            
            // retrieve the property name by calling property_getName function
            let cname = property_getName(property);
            
            // covert the c string into a Swift string
            let name = String(cString: cname!);
            results.append(name);
        }
        
        // release objc_property_t structs
        free(properties);
        
        return results;
    }
    
}

//typealias
typealias JSON = Dictionary<String, Any>

//CGRect
extension CGRect {
    
    func getX() -> CGFloat {
        return self.origin.x
    }
    
    func getY() -> CGFloat {
        return self.origin.y
    }
    
    func getWidth() -> CGFloat {
        return self.size.width
    }
    
    func getHeight() -> CGFloat {
        return self.size.height
    }
}

