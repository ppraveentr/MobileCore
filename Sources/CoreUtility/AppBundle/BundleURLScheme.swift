//
//  BundleURLScheme.swift
//  MobileCore-CoreUtility
//
//  Created by Praveen Prabhakar on 19/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

open class BundleURLScheme {
    
    public static var osVersion: Float {
        NSString(string: UIDevice.current.systemVersion).floatValue
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
