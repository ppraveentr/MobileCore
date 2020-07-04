//
//  Reflection.swift
//  MobileCoreUtility
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public protocol ReflectionProtocol {
        
    static func getClassNameAsString(obj: Any) -> String?
    
    static func getRegisterdModuleIdentifier() -> [String]
    
    /**
     - parameter object: The class that will be used to find the appName for in which we can find classes by string.
     */
    static func registerModuleIdentifier(_ object: Any?)
    
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
    
    /**
     Get the class name as a string from a class
     
     - parameter theObject: An NSObject for whitch the string representation of the class will be returned
     - parameter theObject: An AnyClass for whitch the string representation of the class will be returned
     - returns: The string representation of the class (name of the bundle dot name of the class)
     */
    static func swiftStringFromClass(_ theObject: Any) -> String?
}

public class Reflection: ReflectionProtocol {
    /// Variable that can be set using registermoduleIdentifiers
    // TODO: Make it a SET, so to have unquie elements
    fileprivate static var moduleIdentifiers: [String] = []
    
    /// Character that will be replaced by _ from the keys in a dictionary / json
    fileprivate static let illegalCharacterSet = CharacterSet(charactersIn: " -&%#@!$^*()<>?.,:;")
}

public extension Reflection {
        
    static func getClassNameAsString(obj: Any) -> String? {
        Reflection.swiftStringFromClass(obj)
    }

    static func getRegisterdModuleIdentifier() -> [String] {
        Reflection.moduleIdentifiers
    }
    
    /**
     - parameter object: The class that will be used to find the appName for in which we can find classes by string.
     */
    static func registerModuleIdentifier(_ object: Any? = nil) {
        
        if Reflection.moduleIdentifiers.isEmpty {
            Reflection.moduleIdentifiers.append(Self.nameForBundle(Bundle(for: BundleURLScheme.self)))
        }
        
        if let className = object as? AnyClass {
            Reflection.moduleIdentifiers.append(Self.nameForBundle(Bundle(for: className)))
        }
        else if let classIdentier = object as? String {
            Reflection.moduleIdentifiers.append(classIdentier)
        }
        else if let classes = object as? [Any] {
            for aClass in classes {
                self.registerModuleIdentifier(aClass)
            }
        }
    }
    
    /**
     Get the swift Class type from a string
     
     - parameter className: The string representation of the class (name of the bundle dot name of the class)
     - returns: The Class type
     */
    static func swiftClassTypeFromString(_ className: String) -> AnyClass? {
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
    static func swiftClassFromString(_ className: String) -> NSObject? {
        (Self.swiftClassTypeFromString(className) as? NSObject.Type)?.init()
    }
    
    /**
     Get the class name as a string from a class
     
     - parameter theObject: An NSObject for whitch the string representation of the class will be returned
     - parameter theObject: An AnyClass for whitch the string representation of the class will be returned
     - returns: The string representation of the class (name of the bundle dot name of the class)
     */
    static func swiftStringFromClass(_ theObject: Any) -> String? {
        String(describing: type(of: theObject))
    }
}

fileprivate extension Reflection {
    static func nameForBundle(_ bundle: Bundle) -> String {
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
}
