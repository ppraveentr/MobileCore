//
//  FTAssociatedObject.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public struct FTAssociatedKey {
    static var DefaultKey = "DefaultKey"
}

// Generic way of storing values on runtime
public final class FTAssociatedObject<T> {
    
    private var aoPolicy: objc_AssociationPolicy

    public init(policy aoPolicy: objc_AssociationPolicy) {
        self.aoPolicy = aoPolicy
    }
    
    public convenience init() {
        self.init(policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public subscript(instance: AnyObject) -> T? {
        get {
            return objc_getAssociatedObject(instance, Unmanaged.passUnretained(self).toOpaque()) as? T
        }
        set {
            objc_setAssociatedObject(instance, Unmanaged.passUnretained(self).toOpaque(), newValue, self.aoPolicy)
        }
    }

    // setAssociated
    public static func setAssociated<T>(_ instance: Any, value: T?, key: UnsafeRawPointer? = nil) {
        if let key = key {
            objc_setAssociatedObject(instance, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return
        }
        objc_setAssociatedObject(instance, &FTAssociatedKey.DefaultKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    // getAssociated
    public static func getAssociated(_ instance: Any, key: UnsafeRawPointer? = nil, defaultValue: (() -> T)? = nil) -> T? {
        if let key = key {
            return getValue(instance, key: key, defaultValueBlock: defaultValue)
        }
        return getValue(instance, key: &FTAssociatedKey.DefaultKey, defaultValueBlock: defaultValue)
    }
    
    private static func getValue<T>(_ instance: Any, key: UnsafeRawPointer, defaultValueBlock: (() -> T)? = nil) -> T? {
        let value = objc_getAssociatedObject(instance, key) as? T
        if value == nil, let defaultValue = defaultValueBlock?() {
            setAssociated(instance, value: defaultValue, key: key)
            return defaultValue
        }
        return value
    }
    
    // reset Associated
    public static func resetAssociated(_ instance: Any, key: UnsafeRawPointer? = nil) {
        if let key = key {
            objc_setAssociatedObject(instance, key, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return
        }
        objc_setAssociatedObject(instance, &FTAssociatedKey.DefaultKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
