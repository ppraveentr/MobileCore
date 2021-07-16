//
//  Reflection.swift
//  MobileCoreUtility
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

public protocol ReflectionProtocol {
    /**
    Get the class name as a string from a class
    - parameter obj: An NSObject for whitch the string representation of the class will be returned
    - parameter obj: An AnyClass for whitch the string representation of the class will be returned
    - returns: The string representation of the class (name of the bundle dot name of the class)
    */
    static func getClassNameAsString(_ obj: Any) -> String?
    
    /**
     Get the swift Class type from a string
     - parameter className: The string representation of the class (name of the bundle dot name of the class)
     - returns: The Class type
     */
    static func swiftClassTypeFromString(_ className: String) -> AnyClass?
    
    /**
     Get the swift Class from a string
     - parameter className: The string representation of the class (name of the bundle dot name of the class)
     - returns: The Class type
     */
    static func swiftClassFromString(_ className: String) -> NSObject?
}

public class Reflection: ReflectionProtocol {
    public static func getClassNameAsString(_ obj: Any) -> String? {
        String(describing: type(of: obj))
    }

    public static func swiftClassTypeFromString(_ className: String) -> AnyClass? {
        guard let name = NSClassFromString(className) else { return nil }
        return name
    }

    public static func swiftClassFromString(_ className: String) -> NSObject? {
        (Self.swiftClassTypeFromString(className) as? NSObject.Type)?.init()
    }
}
