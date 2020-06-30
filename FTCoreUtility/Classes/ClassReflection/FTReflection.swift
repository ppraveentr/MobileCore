//
//  FTReflection.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public func getClassNameAsString(obj: Any) -> String? {
    FTReflection.swiftStringFromClass(obj)
}

public final class FTReflection {
    
    /// Variable that can be set using registermoduleIdentifiers
    // TODO: Make it a SET, so to have unquie elements
    fileprivate static var moduleIdentifiers: [String] = []
    
    public static func getRegisterdModuleIdentifier() -> [String] {
        moduleIdentifiers
    }
    
    /**
     - parameter object: The class that will be used to find the appName for in which we can find classes by string.
     */
    public static func registerModuleIdentifier(_ object: Any? = nil) {
        
        if moduleIdentifiers.isEmpty {
            moduleIdentifiers.append(Self.nameForBundle(Bundle(for: self)))
        }
        
        if let className = object as? AnyClass {
            moduleIdentifiers.append(Self.nameForBundle(Bundle(for: className)))
        }
        else if let classIdentier = object as? String {
            moduleIdentifiers.append(classIdentier)
        }
        else if let classes = object as? [Any] {
            for aClass in classes {
                self.registerModuleIdentifier(aClass)
            }
        }
    }
    
    /// Character that will be replaced by _ from the keys in a dictionary / json
    fileprivate static let illegalCharacterSet = CharacterSet(charactersIn: " -&%#@!$^*()<>?.,:;")

    fileprivate static func nameForBundle(_ bundle: Bundle) -> String {
        // get the bundle name from what is set in the infoDictionary
        var appName = bundle.infoDictionary?[kCFBundleExecutableKey as String] as? String ?? ""
        
        // If it was not set, then use the ModuleIdentifier (which is the same as kCFModuleIdentifierKey)
        if appName.isEmpty {
            appName = bundle.bundleIdentifier ?? ""
            appName = appName.split { $0 == "." }.map(String.init).last ?? ""
        }
        
        // Clean up special characters
        return appName.components(separatedBy: illegalCharacterSet).joined(separator: "_")
    }
    
    /**
     Get the swift Class type from a string
     
     - parameter className: The string representation of the class (name of the bundle dot name of the class)
     
     - returns: The Class type
     */
    public static func swiftClassTypeFromString(_ className: String) -> AnyClass? {
        if let name = NSClassFromString(className) {
            return name
        }
        
        for aBundle in moduleIdentifiers {
            if let existingClass = NSClassFromString("\(aBundle).\(className)") {
                return existingClass
            }
        }

        return nil
    }
    
    /**
     Get the swift Class from a string
     
     - parameter className: The string representation of the class (name of the bundle dot name of the class)
     
     - returns: The Class type
     */
    public static func swiftClassFromString(_ className: String) -> NSObject? {
        (Self.swiftClassTypeFromString(className) as? NSObject.Type)?.init()
    }
    
    /**
     Get the class name as a string from a class
     
     - parameter theObject: An NSObject for whitch the string representation of the class will be returned
     - parameter theObject: An AnyClass for whitch the string representation of the class will be returned

     - returns: The string representation of the class (name of the bundle dot name of the class)
     */
    public static func swiftStringFromClass(_ theObject: Any) -> String? {
        
        var className = theObject
        
        if let object = theObject as? NSObject {
            className = type(of: object)
        }
        
        if let object = className as? AnyClass {
            return NSStringFromClass(object).trimming(Self.bundleName(theObject) + ".")
        }
        
        return nil
    }
    
    /**
     Get the app name from the 'Bundle name' and if that's empty, then from the 'Bundle identifier' otherwise we assume it's a EVReflection unit test and use that bundle identifier
     
     - parameter forObject: Pass an object to this method if you know a class from the bundele where you want the name for.
     - parameter aClass: Pass an AnyClass to this method if you know a class from the bundele where you want the name for.
     
     - returns: A cleaned up name of the app.
     */
    public static func bundleName(_ forObject: Any? = nil) -> String {
        // if an object was specified, then always use the bundle name of that class
        if let object = forObject as? NSObject {
            return Self.nameForBundle(Bundle(for: type(of: object)))
        }
        else if let object = forObject as? AnyClass {
            return Self.nameForBundle(Bundle(for: object))
        }
    
        // use the bundle name from the main bundle, if that's not set use the identifier
        return Self.nameForBundle(Bundle.main)
    }
}
