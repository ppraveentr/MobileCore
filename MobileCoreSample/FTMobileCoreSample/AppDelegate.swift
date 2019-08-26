//
//  AppDelegate.swift
//  FTMobileCoreSample
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import MobileCore

@UIApplicationMain
public class AppDelegate: FTAppDelegate {

    override public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FTReflection.registerModuleIdentifier([AppDelegate.self, FTBaseView.self])

        if
            let resource = Bundle.main.path(forResource: "FTMobileCoreBundle", ofType: "bundle"),
            let theme = Bundle(path: resource)?.path(forResource: "Themes", ofType: "json"),
            let themeContent: FTThemeModel = try? theme.jsonContentAtPath()
        {
            FTThemesManager.setupThemes(themes: themeContent, imageSourceBundle: [Bundle(for: AppDelegate.self)])
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
