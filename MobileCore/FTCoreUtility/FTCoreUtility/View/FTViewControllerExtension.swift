//
//  FTViewControllerExtension.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 19/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public extension UIViewController {
    
    // Post notification with Name
    func postNotification(name: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object ?? self)
    }
    
}
