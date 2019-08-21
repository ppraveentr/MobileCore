//
//  FTCoreUtility.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 19/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTCoreUtility {

    // TODO: top-most ViewController in window's rootViewController
    public static var topViewController: UIViewController? {
        get {
            let keyWindow = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow
            guard let rootViewController = keyWindow?.rootViewController else {
                return nil
            }
            return self.topViewController(rootViewController)
        }
    }

    // Get top-most controller in provided `viewController`
    fileprivate static func topViewController(_ viewController: UIViewController?) -> UIViewController? {

        let presentedViewController = viewController?.presentedViewController

        if presentedViewController == nil {
            if let navigationController = viewController as? UINavigationController {
                return navigationController.viewControllers.last
            }
            return viewController
        }

        if let navigationController = presentedViewController as? UINavigationController {
            return self.topViewController(navigationController.viewControllers.last);
        }

        return self.topViewController(presentedViewController)
    }
    
    public static func isRegisteredURLScheme(scheme: String) -> Bool {
        if let bundleURLTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? NSArray {
            for urlType in bundleURLTypes {
                if
                    let urlSchemes = (urlType as? NSDictionary)?.value(forKey: "CFBundleURLSchemes") as? NSArray,
                    urlSchemes.contains(scheme)
                {
                    return true
                }
            }
        }
        return false
    }
}
