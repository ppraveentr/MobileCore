//
//  AppDelegate.swift
//  MobileCoreSample
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

#if canImport(NetworkLayer)
import NetworkLayer
#endif
#if canImport(AppTheming)
import AppTheming
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var kBundle = Bundle(for: AppDelegate.self)
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkMananger.enableConsoleLogging = true
        if let theme = kBundle.path(forResource: "Themes", ofType: "json") {
            ThemesManager.setupThemes(themePath: theme, imageSourceBundle: [kBundle])
        }

        return true
    }
}
