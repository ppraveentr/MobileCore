//
//  UserCacheManager.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/10/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit
//import SwiftKeychainWrapper

// typealias
public typealias NotificationName = Notification.Name

// Notification Constant
public extension NotificationName {
    static let kClearSessionCache = Notification.Name("com.ftmobilecore.clearSessionCache")

    func post(_ object: Any? = nil) {
        NotificationCenter.default.post(name: self, object: object)
    }
}

public enum UserCacheType {
    // will be preserved till user sign's out
    case user
    // will be preserved till applicaion is killed
    case application
    // will be preserved in keychain
    case keychain
}

public protocol UserCacheProtocol {
    // Will Setup userCache
    static var sharedInstance: UserCacheManager { get }
    
    // Application level cache, reset when app relaunches
    var appCache: JSON { get }
    // session cache, clears when user logout
    var userCache: JSON? { get }

    // Set up session
    func setupUserSession()
    // Clear data in Session object
    @discardableResult
    static func clearUserData() -> Bool
    // Session Headers
    static var httpAdditionalHeaders: [String: String]? { get set }
    // Save data to Session object
    @discardableResult
    static func setCacheObject(_ data: AnyObject, key: String, cacheType: UserCacheType) -> Bool
    static func getCachedObject(key: String, cacheType: UserCacheType) -> Any?
    // Save data in Keychain object
//    @discardableResult
//    static func setKeychainObject(_ data: AnyObject, key: String, keychainAccessiblity: KeychainItemAccessibility) -> Bool
//    static func getKeychainObject(key: String, keychainAccessiblity: KeychainItemAccessibility) -> Any?
//    // Save data based on Key: class
//    @discardableResult
//    static func setCacheObject(_ data: AnyObject, forType keyType: AnyClass, cacheType: UserCacheType, keychainAccessiblity: KeychainItemAccessibility) -> Bool
//    static func getCachedObject(forType keyType: AnyClass, cacheType: UserCacheType, keychainAccessiblity: KeychainItemAccessibility) -> Any?
}

public class UserCacheManager: UserCacheProtocol {

    // Will Setup userCache
    public static let sharedInstance = { () -> UserCacheManager in
        let session = UserCacheManager()
        session.setupUserSession()
        return session
    }()

    // Application level cache, reset when app relaunches
    public fileprivate (set) var appCache = JSON()
    // session cache, clears when user logout
    public fileprivate (set) var userCache: JSON?
    // Image cache, clears when user logout
    public fileprivate (set) var imageCache = NSCache<AnyObject, UIImage>()

    public func setupUserSession() {
        // Setup local cache
        if userCache == nil {
            userCache = JSON()
        }
        _ = NotificationCenter.default.addObserver(forName: .kClearSessionCache, object: nil, queue: nil) { _ in
            UserCacheManager.clearUserData()
        }
    }

    // MARK: Session Headers
    public static var httpAdditionalHeaders: [String: String]? {
        get {
            UserCacheManager.getCachedObject(forKey: "sessnion.httpAdditionalHeaders", cacheType: .application) as? [String: String]
        }
        set {
            let data = newValue
            UserCacheManager.setCacheObject(data as AnyObject, forKey: "sessnion.httpAdditionalHeaders", cacheType: .application)
        }
    }
}

public extension UserCacheProtocol {
    @discardableResult
    static func clearUserData() -> Bool {
        UserCacheManager.sharedInstance.userCache = nil
        return true
    }

    // Save data to Session object
    @discardableResult
    static func setCacheObject(_ data: AnyObject, key: String, cacheType: UserCacheType = .user) -> Bool {
        let key = String(describing: key)
        return UserCacheManager.setCacheObject(data, forKey: key, cacheType: cacheType)
    }

    static func getCachedObject(key: String, cacheType: UserCacheType = .user) -> Any? {
        let key = String(describing: key)
        return UserCacheManager.getCachedObject(forKey: key, cacheType: cacheType)
    }

    // Save data in Keychain object
//    @discardableResult
//    static func setKeychainObject(_ data: AnyObject, key: String, keychainAccessiblity: KeychainItemAccessibility) -> Bool {
//        let key = String(describing: key)
//        return UserCacheManager.setCacheObject(data, forKey: key, cacheType: .keychain, keychainAccessiblity: keychainAccessiblity)
//    }
//
//    static func getKeychainObject(key: String, keychainAccessiblity: KeychainItemAccessibility) -> Any? {
//        let key = String(describing: key)
//        return UserCacheManager.getCachedObject(forKey: key, cacheType: .keychain, keychainAccessiblity: keychainAccessiblity)
//    }
//
    // keychainAccessiblity keychain: KeychainItemAccessibility = .whenUnlockedThisDeviceOnly
    @discardableResult
    static func setCacheObject(_ data: AnyObject, forType keyType: AnyClass, cacheType: UserCacheType = .user) -> Bool {
        let key = String(describing: keyType)
        return UserCacheManager.setCacheObject(data, forKey: key, cacheType: cacheType) // keychainAccessiblity: keychain
    }

    // keychainAccessiblity keychain: KeychainItemAccessibility = .whenUnlockedThisDeviceOnly
    static func getCachedObject(forType keyType: AnyClass, cacheType: UserCacheType = .user) -> Any? {
        let key = String(describing: keyType)
        return UserCacheManager.getCachedObject(forKey: key, cacheType: cacheType) // keychainAccessiblity: keychain
    }
}

// MARK: Saving data into: .user, .keychain, .application
private extension UserCacheProtocol {

    // keychainAccessiblity: KeychainItemAccessibility = .whenUnlockedThisDeviceOnly
    @discardableResult
    static func setCacheObject<T>(_ data: AnyObject?, forKey keyType: T, cacheType: UserCacheType) -> Bool where T: Hashable {
        
        let key: String = (keyType as? String) ?? String(describing: keyType)
        
        // USER SESSION LEVEL
        if cacheType == .user {
            UserCacheManager.sharedInstance.userCache?[key] = data
            return true
        }
            // KeyChain LEVEL
//        else if cacheType == .keychain {
//            // Save data if avaialble
//            if let data = data as? Data {
//                return KeychainWrapper.standard.set(data, forKey: key, withAccessibility: keychainAccessiblity)
//            }
//            // else Delete old value
//            return KeychainWrapper.standard.removeObject(forKey: key, withAccessibility: keychainAccessiblity)
//        }
            // APPILCATION LEVEL
        else {

            let key = String(describing: keyType)
            UserCacheManager.sharedInstance.appCache[key] = data
        }

        return true
    }

    // Check-in .user, .keychain, .application
    // keychainAccessiblity: KeychainItemAccessibility = .whenUnlockedThisDeviceOnly
    static func getCachedObject<T>(forKey keyType: T, cacheType: UserCacheType) -> Any? where T: Hashable {

        let key: String = (keyType as? String) ?? String(describing: keyType)

        // USER SESSION LEVEL
        if cacheType == .user, let data = UserCacheManager.sharedInstance.userCache?[key] {
            return data
        }
            // KeyChain LEVEL
//        else if cacheType == .keychain {
//            if let data = KeychainWrapper.standard.data(forKey: key, withAccessibility: keychainAccessiblity) {
//                return data
//            }
//        }
            // APPILCATION LEVEL
        else {
            if let data = UserCacheManager.sharedInstance.appCache[key] {
                return data
            }
        }

        // USER SESSION LEVEL || Keychain data
        if let data = UserCacheManager.sharedInstance.userCache?[key] { //?? KeychainWrapper.standard.data(forKey: key, withAccessibility: keychainAccessiblity) {
            return data
        }

        return nil
    }
}
