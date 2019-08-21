//
//  FTModelUtility.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 28/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public let FTInstanceSwizzling: (AnyClass, Selector, Selector) -> () = { klass, originalSelector, swizzledSelector in
    let originalMethod = class_getInstanceMethod(klass, originalSelector)
    let swizzledMethod = class_getInstanceMethod(klass, swizzledSelector)
    let didAddMethod = class_addMethod(klass, originalSelector,
                                       method_getImplementation(swizzledMethod!),
                                       method_getTypeEncoding(swizzledMethod!))
    
    if didAddMethod {
        class_replaceMethod(klass, swizzledSelector,
                            method_getImplementation(originalMethod!),
                            method_getTypeEncoding(originalMethod!))
    } else {
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }    
}
