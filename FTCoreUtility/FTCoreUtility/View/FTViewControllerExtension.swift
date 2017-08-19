//
//  FTViewControllerExtension.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 19/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public func topViewController() -> UIViewController? {
    
    var topController = UIApplication.shared.keyWindow?.rootViewController
    
    while ((topController?.presentedViewController) != nil) {
        topController = topController?.presentedViewController
    }
    
    return topController
}
