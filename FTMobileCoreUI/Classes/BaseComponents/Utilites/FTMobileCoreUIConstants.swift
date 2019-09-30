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
    static let kFTMobileCoreDidLoadViewController = Notification.Name("FTMobileCore.ViewController.DidLoad")
    static let kFTMobileCoreWillAppearViewController = Notification.Name("FTMobileCore.ViewController.WillAppear")
    static let kFTMobileCoreDidAppearViewController = Notification.Name("FTMobileCore.ViewController.DidAppear")
    static let kFTMobileCoreWillDisappearViewController = Notification.Name("FTMobileCore.ViewController.WillDisappear")
    static let kFTMobileCoreDidDisappearViewController = Notification.Name("FTMobileCore.ViewController.DidDisappear")
    static let kFTMobileCoreDidLayoutSubviews = Notification.Name("FTMobileCore.ViewController.DidLayoutSubviews")
}
