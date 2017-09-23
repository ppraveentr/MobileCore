//
//  FTAssociatedObject.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

//Generic way of storing values on runtime
public class FTAssociatedObject<T> {
    
    private let aoPolicy: objc_AssociationPolicy

    public init(policy aoPolicy:objc_AssociationPolicy) {
        self.aoPolicy = aoPolicy
    }
    
    public convenience init(){
        self.init(policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public subscript(instance: AnyObject) -> T? {
        get { return objc_getAssociatedObject(instance, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(instance, Unmanaged.passUnretained(self).toOpaque(), newValue, self.aoPolicy)}
    }
}
