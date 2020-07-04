//
//  AppDelegate.swift
//  MobileCoreUtility
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class AppDelegate: UIResponder, UIApplicationDelegate {
    open var window: UIWindow?
    
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        MobileCoreUIConfig.setupMobileCoreUI(.all)
        
        // Register self's type as Bundle-Identifier for getting class name
        Reflection.registerModuleIdentifier(AppDelegate.self)
        
        return true
    }
}
