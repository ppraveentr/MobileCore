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
    
    public class func getRegisterdModuleIdentifier() -> [String] {
        moduleIdentifiers
    }
    
    /**
     - parameter object: The class that will be used to find the appName for in which we can find classes by string.
     */
    public class func registerModuleIdentifier(_ object: Any? = nil) {
        
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

    fileprivate class func nameForBundle(_ bundle: Bundle) -> String {
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
    public class func swiftClassTypeFromString(_ className: String) -> AnyClass? {
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
        String(describing: type(of: theObject))
    }
}
