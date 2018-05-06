//
//  AppDelegate.swift
//  FTMobileCoreSample
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: FTAppDelegate {

    public override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FTReflection.registerModuleIdentifier([AppDelegate.self,FTBaseView.self])

        if
            let resource = Bundle.main.path(forResource: "MobileCodeSampleBundle", ofType: "bundle"),
            let theme = Bundle(path: resource)?.path(forResource: "Themes", ofType: "json"),
            let themeContent: FTThemeDic = try! theme.jsonContentAtPath() {

            FTThemesManager.setupThemes(themes: themeContent, imageSourceBundle: [Bundle(for: AppDelegate.self)])
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

}

