//
//  AppDelegate.swift
//  FTMobileCoreSample
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

@UIApplicationMain
public class AppDelegate: FTAppDelegate {

    override public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let theme = kFTMobileCoreBundle?.path(forResource: "Themes", ofType: "json") {
            FTThemesManager.setupThemes(themePath: theme, imageSourceBundle: [Bundle(for: AppDelegate.self)])
        }
                
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
