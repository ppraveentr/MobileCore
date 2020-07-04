//
//  AppDelegate.swift
//  FTMobileCoreSample
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

@UIApplicationMain
public class AppDelegate: MobileCore.AppDelegate {

    override public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let theme = kMobileCoreBundle?.path(forResource: "Themes", ofType: "json") {
            ThemesManager.setupThemes(themePath: theme, imageSourceBundle: [Bundle(for: AppDelegate.self)])
        }
                
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
