//
//  FTAssociatedObject.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

fileprivate var AssociatedObjectDescriptiveName = "FTAssociatedObject_AssociatedObjectDescriptiveName"

// Generic way of storing values on runtime
public class FTAssociatedObject<T> {
    
    private var aoPolicy: objc_AssociationPolicy

    public init(policy aoPolicy:objc_AssociationPolicy) {
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

    public static func setAssociated<T>(instance: Any, value: T?) {
        objc_setAssociatedObject(instance, &AssociatedObjectDescriptiveName, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    public static func getAssociated(instance: Any) -> T? {
        return objc_getAssociatedObject(instance, &AssociatedObjectDescriptiveName) as? T
    }
    
}
