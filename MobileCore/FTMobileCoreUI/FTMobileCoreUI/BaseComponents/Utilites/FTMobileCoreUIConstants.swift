//
//  FTMobileCoreUIConstants.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 18/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

// Notification constans name
public extension Notification.Name {
    // ViewController - lifeCycle changes
    static let FTMobileCoreDidLoadViewController = Notification.Name("FTMobileCore.ViewController.DidLoad")
    static let FTMobileCoreWillAppearViewController = Notification.Name("FTMobileCore.ViewController.WillAppear")
    static let FTMobileCoreDidAppearViewController = Notification.Name("FTMobileCore.ViewController.DidAppear")
    static let FTMobileCoreWillDisappearViewController = Notification.Name("FTMobileCore.ViewController.WillDisappear")
    static let FTMobileCoreDidDisappearViewController = Notification.Name("FTMobileCore.ViewController.DidDisappear")
}
