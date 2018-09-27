//
//  FTModelUtility.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 28/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public let FTInstanceSwizzling: (AnyClass, Selector, Selector) -> () = { klass, originalSelector, swizzledSelector in
    
    let originalMethod = class_getInstanceMethod(klass, originalSelector)
    let swizzledMethod = class_getInstanceMethod(klass, swizzledSelector)
    
    let didAddMethod = class_addMethod(klass, originalSelector,
                                       method_getImplementation(swizzledMethod!),
                                       method_getTypeEncoding(swizzledMethod!))
    
    if didAddMethod {
        class_replaceMethod(klass, swizzledSelector,
                            method_getImplementation(originalMethod!),
                            method_getTypeEncoding(originalMethod!))
    } else {
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
}

fileprivate let baseTypesMap: Dictionary<String, Any> = [
    "c" : Int8.self,
    "s" : Int16.self,
    "i" : Int32.self,
    "q" : Int.self, //also: Int64, NSInteger, only true on 64 bit platforms
    "S" : UInt16.self,
    "I" : UInt32.self,
    "Q" : UInt.self, //also UInt64, only true on 64 bit platforms
    "B" : Bool.self,
    "d" : Double.self,
    "f" : Float.self,
    "{" : Decimal.self
]

/*
 *  This can find name and type of "value type" such as Bool, Int, Int32
 *  _HOWEVER_ this does not work if its an optional type.
 *  e.g. Int? <--- DOES NOT WORK
 */
//public func getClassPropertyNames(_ myClass: Any) -> Dictionary<String,Any>? {
//    
//    var results: Dictionary<String,Any> = [:]
//    
//    // retrieve the properties via the class_copyPropertyList function
//    var count: UInt32 = 0
//    
//    // TODO : throws
//    guard let properties = class_copyPropertyList(type(of: myClass) as! AnyClass, &count) else { return nil }
//    
//    // iterate each objc_property_t struct
//    for i in 0 ..< Int(count) {
//        
//        guard
//            // property
//            let property: objc_property_t? = properties[i],
//            // property name
//            let cname = property_getName(property),
//            // property Attributes
//            let cattribure = property_getAttributes(property)
//            else { continue }
//        
//        let attribure = String(cString: cattribure)
//        let name = String(cString: cname)
//        
//        results[name] = attribure.get_propertyAttributeType()
//    }
//    
//    // release objc_property_t structs
//    free(properties)
//    
//    return results
//}

//String Extension
public extension String {
    
    func get_propertyAttributeWithBaseType() -> Any {
        // TB,N,Vid
        guard
            let letter = self.substring(from: 1, to: 2),
            let type = baseTypesMap[letter]
            else { return Any.self }
        return type
    }
    
    func get_propertyAttributeType() -> Any {
        
        var attribure: Any?
        
        // T@"NSMutableArray",N,&,Vid
        self.enumerate(pattern: "(?<=T@\")([\\w]+)(?=\",)") { (result) in
            if
                let range = result?.range,
                let subText = self.substring(with: range) {
                attribure = subText
            }
        }
        
        // TB,N,Vid
        guard let type = attribure else {
            return self.get_propertyAttributeWithBaseType()
        }
        
        return NSClassFromString(type as! String) ?? Any.self
    }
}
