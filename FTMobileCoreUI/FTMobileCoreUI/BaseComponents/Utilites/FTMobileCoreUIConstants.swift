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
    static let FTMobileCoreUI_ViewController_DidLoad = Notification.Name("FTMobileCoreUI_ViewController_DidLoad")
    static let FTMobileCoreUI_ViewController_WillAppear = Notification.Name("FTMobileCoreUI_ViewController_WillAppear")
    static let FTMobileCoreUI_ViewController_DidAppear = Notification.Name("FTMobileCoreUI_ViewController_DidAppear")
    static let FTMobileCoreUI_ViewController_WillDisappear = Notification.Name("FTMobileCoreUI_ViewController_WillDisappear")
    static let FTMobileCoreUI_ViewController_DidDisappear = Notification.Name("FTMobileCoreUI_ViewController_DidDisappear")
}
