//
//  CoreUIExtensionsConstants.swift
//  CoreUIExtensions
//
//  Created by Praveen Prabhakar on 18/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public struct ViewNotificationType: OptionSet {
    public let rawValue: UInt

    public init(rawValue: UInt) { self.rawValue = rawValue }
    public init(_ rawValue: UInt) { self.rawValue = rawValue }

    // View Notification
    public static let willAppearViewController = ViewNotificationType(1 << 1)
    public static let didAppearViewController = ViewNotificationType(1 << 2)
    public static let willDisappearViewController = ViewNotificationType(1 << 3)
    public static let didDisappearViewController = ViewNotificationType(1 << 4)
    public static let didLayoutSubviews = ViewNotificationType(1 << 5)
    
    public static let all: ViewNotificationType = [
        .willAppearViewController,
        .didAppearViewController,
        .willDisappearViewController,
        .didDisappearViewController,
        .didLayoutSubviews
    ]
}

// Notification constans name
extension Notification.Name {
    // ViewController - lifeCycle changes
    static let kFTMobileCoreWillAppearViewController = Notification.Name("FTMobileCore.ViewController.WillAppear")
    static let kFTMobileCoreDidAppearViewController = Notification.Name("FTMobileCore.ViewController.DidAppear")
    static let kFTMobileCoreWillDisappearViewController = Notification.Name("FTMobileCore.ViewController.WillDisappear")
    static let kFTMobileCoreDidDisappearViewController = Notification.Name("FTMobileCore.ViewController.DidDisappear")
    static let kFTMobileCoreDidLayoutSubviews = Notification.Name("FTMobileCore.ViewController.DidLayoutSubviews")
}

// MARK: Notification whenever view is loaded
extension UIViewController {
    
    // Swizzling out view's layoutSubviews property for Updating Visual theme
    static func swizzleViewController(_ type: ViewNotificationType = .all) {
        if type.contains(.didAppearViewController) {
            instanceMethodSwizzling(UIViewController.self, #selector(viewDidAppear(_:)), #selector(swizzledviewDidAppear(_:)))
        }
        if type.contains(.willAppearViewController) {
            instanceMethodSwizzling(UIViewController.self, #selector(viewWillAppear(_:)), #selector(swizzledviewWillAppear(_:)))
        }
        if type.contains(.willDisappearViewController) {
            instanceMethodSwizzling(UIViewController.self, #selector(viewWillDisappear(_:)), #selector(swizzledviewWillDisappear(_:)))
        }
        if type.contains(.didDisappearViewController) {
            instanceMethodSwizzling(UIViewController.self, #selector(viewDidDisappear(_:)), #selector(swizzledviewDidDisappear(_:)))
        }
        if type.contains(.didLayoutSubviews) {
            instanceMethodSwizzling(UIViewController.self, #selector(viewDidLayoutSubviews), #selector(swizzledviewDidLayoutSubviews))
        }
    }
    
    @objc func swizzledviewWillAppear(_ animated: Bool) {
        postNotification(name: .kFTMobileCoreWillAppearViewController)
        self.swizzledviewWillAppear(animated)
    }
    
    @objc func swizzledviewDidAppear(_ animated: Bool) {
        self.swizzledviewDidAppear(animated)
        postNotification(name: .kFTMobileCoreDidAppearViewController)
    }
    
    @objc func swizzledviewWillDisappear(_ animated: Bool) {
        postNotification(name: .kFTMobileCoreWillDisappearViewController)
        self.swizzledviewWillDisappear(animated)
    }
    
    @objc func swizzledviewDidDisappear(_ animated: Bool) {
        self.swizzledviewDidDisappear(animated)
        postNotification(name: .kFTMobileCoreDidDisappearViewController)
    }
    
    @objc func swizzledviewDidLayoutSubviews() {
        self.swizzledviewDidLayoutSubviews()
        postNotification(name: .kFTMobileCoreDidLayoutSubviews)
    }
}
