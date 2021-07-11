//
//  AppDelegate.swift
//  MobileCoreSample
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

@UIApplicationMain
public class AppDelegate: MobileCore.AppDelegate {
    var kBundle = Bundle(for: AppDelegate.self)

    override public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkMananger.enableConsoleLogging = true
        if let theme = kBundle.path(forResource: "Themes", ofType: "json") {
            ThemesManager.setupThemes(themePath: theme, imageSourceBundle: [kBundle])
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
