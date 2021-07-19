//
//  AssociatedObject.swift
//  MobileCore-CoreUtility
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

public enum AssociatedKey {
    public static var defaultKey = "AssociatedKey.defaultKey"
}

// Generic way of storing values on runtime
public final class AssociatedObject<T> {
    
    private var aoPolicy: objc_AssociationPolicy

    public init(policy aoPolicy: objc_AssociationPolicy) {
        self.aoPolicy = aoPolicy
    }
    
    public convenience init() {
        self.init(policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public subscript(instance: AnyObject) -> T? {
        get {
            objc_getAssociatedObject(instance, Unmanaged.passUnretained(self).toOpaque()) as? T
        }
        set {
            objc_setAssociatedObject(instance, Unmanaged.passUnretained(self).toOpaque(), newValue, self.aoPolicy)
        }
    }

    // setAssociated
    public static func setAssociated(_ instance: Any, value: T?, key: UnsafeRawPointer? = nil) {
        if let key = key {
            objc_setAssociatedObject(instance, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return
        }
        objc_setAssociatedObject(instance, &AssociatedKey.defaultKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    // getAssociated
    public static func getAssociated(_ instance: Any, key: UnsafeRawPointer? = nil, defaultValue: (() -> T)? = nil) -> T? {
        if let key = key {
            return getValue(instance, key: key, defaultValueBlock: defaultValue)
        }
        return getValue(instance, key: &AssociatedKey.defaultKey, defaultValueBlock: defaultValue)
    }
    
    private static func getValue(_ instance: Any, key: UnsafeRawPointer, defaultValueBlock: (() -> T)? = nil) -> T? {
        guard let value = objc_getAssociatedObject(instance, key) as? T else {
            if let defaultValue: T = defaultValueBlock?() {
                setAssociated(instance, value: defaultValue, key: key)
                return defaultValue
            }
            return nil
        }
        
        return value
    }
    
    // reset Associated
    public static func resetAssociated(_ instance: Any, key: UnsafeRawPointer? = nil) {
        if let key = key {
            objc_setAssociatedObject(instance, key, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return
        }
        objc_setAssociatedObject(instance, &AssociatedKey.defaultKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
