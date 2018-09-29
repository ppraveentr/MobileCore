//
//  FTCoreUtility.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 19/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTCoreUtility {

    //TODO: top-most ViewController in window's rootViewController
    public static var topViewController: UIViewController? {
        get {
            let keyWindow = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow
            guard let rootViewController = keyWindow?.rootViewController else { return nil }
            return self.topViewController(rootViewController)
        }
    }

    //Get top-most controller in provided `viewController`
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
}

//+ (BOOL)isRegisteredURLScheme:(NSString *)urlScheme {
//    static dispatch_once_t fetchBundleOnce;
//    static NSArray *urlTypes = nil;
//    
//    dispatch_once(&fetchBundleOnce, ^{
//    urlTypes = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleURLTypes"];
//    });
//    for (NSDictionary *urlType in urlTypes) {
//        NSArray *urlSchemes = [urlType valueForKey:@"CFBundleURLSchemes"];
//        if ([urlSchemes containsObject:urlScheme]) {
//            return YES;
//        }
//    }
//    return NO;
//}

//+ (unsigned long)currentTimeInMilliseconds
//    {
//        struct timeval time
//        gettimeofday(&time, NULL)
//        return (time.tv_sec * 1000) + (time.tv_usec / 1000)
//}
