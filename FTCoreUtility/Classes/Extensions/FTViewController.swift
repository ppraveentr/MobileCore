//
//  FTViewController.swift
//  MobileCore
//
//  Created by Praveen P on 07/09/19.
//  Copyright © 2019 Praveen P. All rights reserved.
//

import Foundation

public extension UIViewController {
    
    // Get top-most controller
    var currentViewController: UIViewController? {
        let keyWindow = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow
        guard let rootViewController = keyWindow?.rootViewController else {
            return nil
        }
        return UIViewController.currentViewController(rootViewController)
    }
    
    // Get top-most controller in provided `viewController`
    static func currentViewController(_ viewController: UIViewController?) -> UIViewController? {
        
        let presentedViewController = viewController?.presentedViewController
        
        if presentedViewController == nil {
            if let navigationController = viewController as? UINavigationController {
                return navigationController.viewControllers.last
            }
            return viewController
        }
        
        if let navigationController = presentedViewController as? UINavigationController {
            return self.currentViewController(navigationController.viewControllers.last)
        }
        
        return self.currentViewController(presentedViewController)
    }
}

public extension UIViewController {
    
    // Post notification with Name
    func postNotification(name: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object ?? self)
    }
}
