//
//  FTReflection.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public func get_classNameAsString(obj: Any) -> String? {
    return FTReflection.swiftStringFromClass(obj)
}

//String Extension
public extension String {
    
    //String Extension
    func getClassInstance () -> AnyClass? {
        return FTReflection.swiftClassTypeFromString(self)
    }
}
final public class FTReflection {
    
    /// Variable that can be set using registerBundleIdentifiers
    fileprivate static var bundleIdentifiers: [String]? = []
    
    /**
     - parameter object: The class that will be used to find the appName for in which we can find classes by string.
     */
    public class func registerBundleIdentifier(_ object: Any? = nil) {
        
        if bundleIdentifiers?.count == 0 {
            bundleIdentifiers?.append(nameForBundle(Bundle(for: self)))
        }
        
        if let className = object as? AnyClass {
            bundleIdentifiers?.append(nameForBundle(Bundle(for: className)))
        }
        else if let classIdentier = object as? String {
            bundleIdentifiers?.append(classIdentier)
        }
        else if let classes = object as? Array<Any> {
            for aClass in classes {
                self.registerBundleIdentifier(aClass)
            }
        }
    }
    
    /// Character that will be replaced by _ from the keys in a dictionary / json
    fileprivate static let illegalCharacterSet = CharacterSet(charactersIn: " -&%#@!$^*()<>?.,:;")

    fileprivate static func nameForBundle(_ bundle: Bundle) -> String {
        // get the bundle name from what is set in the infoDictionary
        var appName = bundle.infoDictionary?[kCFBundleExecutableKey as String] as? String ?? ""
        
        // If it was not set, then use the bundleIdentifier (which is the same as kCFBundleIdentifierKey)
        if appName == "" {
            appName = bundle.bundleIdentifier ?? ""
            appName = appName.characters.split(whereSeparator: {$0 == "."}).map({ String($0) }).last ?? ""
        }
        
        // Clean up special characters
        return appName.components(separatedBy: illegalCharacterSet).joined(separator: "_")
    }
    
    
    /**
     Get the swift Class type from a string
     
     - parameter className: The string representation of the class (name of the bundle dot name of the class)
     
     - returns: The Class type
     */
    public class func swiftClassTypeFromString(_ className: String) -> AnyClass? {
        if let c = NSClassFromString(className) {
            return c
        }
        
        if let bundleIdentifiers = bundleIdentifiers {
            for aBundle in bundleIdentifiers {
                if let existingClass = NSClassFromString("\(aBundle).\(className)") {
                    return existingClass
                }
            }
        }
        
        return nil
    }
    
    /**
     Get the swift Class from a string
     
     - parameter className: The string representation of the class (name of the bundle dot name of the class)
     
     - returns: The Class type
     */
    public class func swiftClassFromString(_ className: String) -> NSObject? {
        return (swiftClassTypeFromString(className) as? NSObject.Type)?.init()
    }
    
    /**
     Get the class name as a string from a class
     
     - parameter theObject: An NSObject for whitch the string representation of the class will be returned
     - parameter theObject: An AnyClass for whitch the string representation of the class will be returned

     - returns: The string representation of the class (name of the bundle dot name of the class)
     */
    public class func swiftStringFromClass(_ theObject: Any) -> String? {
        
        var classNanme = theObject
        
        if let object = theObject as? NSObject {
            classNanme = type(of: object)
        }
        
        if let object = classNanme as? AnyClass {
           return NSStringFromClass(object).trimming(string: getCleanAppName(theObject) + ".")
        }
        
        return nil
    }
    
    /**
     Get the app name from the 'Bundle name' and if that's empty, then from the 'Bundle identifier' otherwise we assume it's a EVReflection unit test and use that bundle identifier
     
     - parameter forObject: Pass an object to this method if you know a class from the bundele where you want the name for.
     - parameter aClass: Pass an AnyClass to this method if you know a class from the bundele where you want the name for.
     
     - returns: A cleaned up name of the app.
     */
    public class func getCleanAppName(_ forObject: Any? = nil) -> String {
        // if an object was specified, then always use the bundle name of that class
        if let object = forObject as? NSObject {
            return nameForBundle(Bundle(for: type(of: object)))
        }
        else if let object = forObject as? AnyClass {
            return nameForBundle(Bundle(for: object))
        }
    
        // use the bundle name from the main bundle, if that's not set use the identifier
        return nameForBundle(Bundle.main)
    }
}