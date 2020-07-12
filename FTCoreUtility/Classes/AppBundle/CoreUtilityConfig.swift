//
//  CoreUtilityConfig.swift
//  MobileCore
//
//  Created by Praveen Prabhakar on 04/07/20.
//

import Foundation

public class CoreUtilityConfig {
    
    static let sharedInstance = CoreUtilityConfig()

    public static func setupMobileCoreUI(_ notificationType: ViewNotificationType = .all) {
        self.registerUINotifications(notificationType)
    }
    
    public static func registerUINotifications(_ notificationType: ViewNotificationType = .all) {
        UIViewController.swizzleViewController(notificationType)
    }
}
