//
//  MobileCoreUIConfig.swift
//  MobileCore
//
//  Created by Praveen P on 18/10/19.
//

import Foundation

public class MobileCoreUIConfig {
    
    static let sharedInstance = MobileCoreUIConfig()

    public static func setupMobileCoreUI(_ notificationType: ViewNotificationType = .all) {
        Reflection.registerModuleIdentifier(FontPickerView.self)
        
        MobileCoreUIConfig.registerUINotifications(notificationType)
    }
    
    public static func registerUINotifications(_ notificationType: ViewNotificationType = .all) {
        UIViewController.swizzleViewController(notificationType)
    }
}
