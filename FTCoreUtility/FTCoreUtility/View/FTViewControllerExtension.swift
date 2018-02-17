//
//  FTViewControllerExtension.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 19/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

//Get top-most ViewController in window
public func TopViewController() -> UIViewController? {
    
    var topController = UIApplication.shared.keyWindow?.rootViewController
    
    while ((topController?.presentedViewController) != nil) {
        topController = topController?.presentedViewController
    }
    
    return topController
}

public extension UIViewController {
    
    //Post notification with Name
    func postNotification(name: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object ?? self)
    }
}
