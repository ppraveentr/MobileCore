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

public struct AssociatedKey {
    static var DefaultKey = "DefaultKey"
}

// Generic way of storing values on runtime
public class FTAssociatedObject<T> {
    
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
    public static func setAssociated<T>(_ instance: Any, value: T?) {
        setAssociated(instance, value: value, key: &FTAssociatedKey.DefaultKey)
    }
    
    public static func setAssociated<T>(_ instance: Any, value: T?, key: UnsafeRawPointer) {
        objc_setAssociatedObject(instance, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    // getAssociated
    public static func getAssociated(_ instance: Any) -> T? {
        return getAssociated(instance, key: &FTAssociatedKey.DefaultKey)
    }

    public static func getAssociated(_ instance: Any, key: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(instance, key) as? T
    }
    
    // reset Associated
    public static func resetAssociated(_ instance: Any, key: UnsafeRawPointer) {
        objc_setAssociatedObject(instance, key, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public static func resetAssociated(_ instance: Any) {
        objc_setAssociatedObject(instance, &FTAssociatedKey.DefaultKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
