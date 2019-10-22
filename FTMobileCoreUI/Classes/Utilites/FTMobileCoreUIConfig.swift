//
//  FTMobileCoreUIConfig.swift
//  MobileCore
//
//  Created by Praveen P on 18/10/19.
//

import Foundation

public class FTMobileCoreUIConfig {
    
    static let sharedInstance = FTMobileCoreUIConfig()

    public static func setupMobileCoreUI(_ notificationType: FTUIViewNotificationType = .all) {
        FTReflection.registerModuleIdentifier(FTFontPickerView.self)
        
        FTMobileCoreUIConfig.registerUINotifications(notificationType)
    }
    
    public static func registerUINotifications(_ notificationType: FTUIViewNotificationType = .all) {
        UIViewController.swizzleViewController(notificationType)
    }
}
