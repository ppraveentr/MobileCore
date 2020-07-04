//
//  FTUserCache.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/10/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

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

open class UserCache {
    var userCache = JSON()

    // Save data to Session object
    func setCacheObject(_ data: AnyObject?, forKey keyType: String) {
        self.userCache[keyType] = data
    }

    func getCachedObject(forKey keyType: String) -> Any? {
        self.userCache[keyType]
    }
}

open class UserCacheManager {

    public static let sharedInstance = { () -> UserCacheManager in
        UserCacheManager.setupSession()
        return UserCacheManager()
    }()

    // Application level cache, reset when app relaunches
    fileprivate var dataDictionary = JSON()
    // session cache, clears when user logout
    fileprivate var localCache: UserCache?

    public static var userCache: UserCache {
        // Will be set-to nil when user logsOut
        if UserCacheManager.sharedInstance.localCache == nil {
            UserCacheManager.sharedInstance.localCache = UserCache()
        }
        return UserCacheManager.sharedInstance.localCache!
    }

    public static func setupSession() {
        //
        _ = NotificationCenter.default.addObserver(forName: .kClearSessionCache, object: nil, queue: nil) { _ in
            UserCacheManager.clearUserData()
        }
    }

    // MARK: Session Headers
    public static var httpAdditionalHeaders: [String: String]? {
        set {
            let data = newValue
            UserCacheManager.setCacheObject(data as AnyObject, forKey: "sessnion.httpAdditionalHeaders", cacheType: .application)
        }
        get {
            UserCacheManager.getCachedObject(forKey: "sessnion.httpAdditionalHeaders") as? [String: String]
        }
    }
}

public extension UserCacheManager {

    // httpAdditionalHeaders
    static func defaultSessionHeaders() -> [String: String] {
        var headers = [String: String]()
        UserCacheManager.httpAdditionalHeaders?.forEach { key, value in
            headers[key] = value
        }
        return headers
    }
}

public extension UserCacheManager {

    @discardableResult
    static func clearUserData() -> Bool {
        UserCacheManager.sharedInstance.localCache = nil
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

    @discardableResult
    static func setCacheObject(_ data: AnyObject, forType keyType: AnyClass, cacheType: UserCacheType = .user) -> Bool {
        let key = String(describing: keyType)
        return UserCacheManager.setCacheObject(data, forKey: key, cacheType: cacheType)
    }

    static func getCachedObject(forType keyType: AnyClass, cacheType: UserCacheType = .user) -> Any? {
        let key = String(describing: keyType)
        return UserCacheManager.getCachedObject(forKey: key, cacheType: cacheType)
    }
}

// MARK: Saving data into: .user, .keychain, .application
private extension UserCacheManager {

    @discardableResult
    static func setCacheObject<T>(_ data: AnyObject?, forKey keyType: T, cacheType: UserCacheType = .user) -> Bool where T: Hashable {

        let key: String = (keyType as? String) ?? String(describing: keyType)

        // USER SESSION LEVEL
        if cacheType == .user {
            UserCacheManager.userCache.setCacheObject(data, forKey: key)
            return true
        }
            // KeyChain LEVEL
        else if cacheType == .keychain {
            // Save data if avaialble
            if let data = data as? Data {
                return KeychainWrapper.standard.set(data, forKey: key, withAccessibility: .whenUnlocked)
            }
            // else Delete old value
            return KeychainWrapper.standard.removeObject(forKey: key, withAccessibility: .whenUnlocked)
        }
            // APPILCATION LEVEL
        else {

            let key = String(describing: keyType)
            UserCacheManager.sharedInstance.dataDictionary[key] = data
        }

        return true
    }

    // Check-in .user, .keychain, .application
    static func getCachedObject<T>(forKey keyType: T, cacheType: UserCacheType = .user) -> Any? where T: Hashable {

        let key: String = (keyType as? String) ?? String(describing: keyType)

        // USER SESSION LEVEL
        if cacheType == .user, let data = UserCacheManager.userCache.getCachedObject(forKey: key) {
            return data
        }
            // KeyChain LEVEL
        else if cacheType == .keychain {
            if let data = KeychainWrapper.standard.data(forKey: key, withAccessibility: .whenUnlocked) {
                return data
            }
        }
            // APPILCATION LEVEL
        else {
            if let data = UserCacheManager.sharedInstance.dataDictionary[key] {
                return data
            }
        }

        // USER SESSION LEVEL
        if let data = UserCacheManager.userCache.getCachedObject(forKey: key) {
            return data
        }
            // KeyChain
        else if let data = KeychainWrapper.standard.data(forKey: key, withAccessibility: .whenUnlocked) {
            return data
        }

        return nil
    }
}
