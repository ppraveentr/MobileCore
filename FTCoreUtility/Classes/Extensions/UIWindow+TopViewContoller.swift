//
//  UIWindow+RootViewContoller.swift
//  FactsCheck
//
//  Created by Praveen P on 09/04/20.
//  Copyright © 2020 Praveen P. All rights reserved.
//

import UIKit

// Screen width.
public var screenWidth: CGFloat {
    UIScreen.main.bounds.width
}

// Screen height.
public var screenHeight: CGFloat {
    UIScreen.main.bounds.height
}

public extension UIWindow {
    /// Returns the current application's top most view controller.
    class var topViewController: UIViewController? {
        UIApplication.shared.currentViewController
    }
}

public extension UIViewController {
    // Post notification with Name
    func postNotification(name: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object ?? self)
    }
}

public extension UIApplication {
    var currentViewController: UIViewController? {
        keyWindow?.rootViewController?.currentViewController
    }
}

public extension UIViewController {
    /// Returns the top most view controller
    var currentViewController: UIViewController {
        // presented view controller
        if let presented = presentedViewController {
            return presented.currentViewController
        }
        
        // UITabBarController
        if let tab = self as? UITabBarController,
            let selectedViewController = tab.selectedViewController {
            return selectedViewController.currentViewController
        }
        
        // UINavigationController
        if let navigationController = self as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return visibleViewController.currentViewController
        }
        
        // UIPageController
        if let pageViewController = self as? UIPageViewController,
            let firstPageViewController = pageViewController.viewControllers?.first,
            pageViewController.viewControllers?.count == 1 {
            return firstPageViewController.currentViewController
        }
        
        // child view controller
        if let subviews = view?.subviews {
            for subview in subviews {
                if let childViewController = subview.next as? UIViewController {
                    return childViewController.currentViewController
                }
            }
        }
        
        return self
    }
}
