//
//  FTMobileCoreUIConfig.swift
//  MobileCore
//
//  Created by Praveen P on 18/10/19.
//

import Foundation

public class FTMobileCoreUIConfig {
    
    static let sharedInstance = FTMobileCoreUIConfig()

    public static func registerUINotifications(_ type: FTUIViewNotificationType = .all) {
        UIViewController.swizzleViewController(type)
    }
}
