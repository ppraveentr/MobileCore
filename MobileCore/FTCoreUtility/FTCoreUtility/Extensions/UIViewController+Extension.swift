//
//  UIViewController+Extension.swift
//  MobileCore
//
//  Created by Praveen P on 07/09/19.
//  Copyright © 2019 Praveen P. All rights reserved.
//

import Foundation

public extension UIViewController {
    
    // Get top-most controller
    var topViewController: UIViewController? {
        let keyWindow = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow
        guard let rootViewController = keyWindow?.rootViewController else {
            return nil
        }
        return UIViewController.topViewController(rootViewController)
    }
    
    // Get top-most controller in provided `viewController`
    static func topViewController(_ viewController: UIViewController?) -> UIViewController? {
        
        let presentedViewController = viewController?.presentedViewController
        
        if presentedViewController == nil {
            if let navigationController = viewController as? UINavigationController {
                return navigationController.viewControllers.last
            }
            return viewController
        }
        
        if let navigationController = presentedViewController as? UINavigationController {
            return self.topViewController(navigationController.viewControllers.last)
        }
        
        return self.topViewController(presentedViewController)
    }
    
}
