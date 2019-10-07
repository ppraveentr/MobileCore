//
//  FTSessionCache.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/10/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

// typealias
public typealias FTNotification = Notification.Name

// Notification Constant
public extension FTNotification {
    static let kFTClearSessionCache = Notification.Name("com.ftmobilecore.notification.name.clearSession.Application")

    func post(_ object: Any? = nil) {
        NotificationCenter.default.post(name: self, object: object)
    }
}

public enum FTUserCacheType {
    // will be preserved till user sign's out
    case user
    // will be preserved till applicaion is killed
    case application
    // will be preserved in keychain
    case keychain
}

open class FTCache {
    var userCache = JSON()

    // Save data to Session object
    func setCacheObject(_ data: AnyObject?, forKey keyType: String) {
        self.userCache[keyType] = data
    }

    func getCachedObject(forKey keyType: String) -> Any? {
        return self.userCache[keyType]
    }
}

open class FTUserCache {

    public static let sharedInstance = { () -> FTUserCache in
        FTUserCache.setupSession()
        return FTUserCache()
    }()

    // Application level cache, reset when app relaunches
    fileprivate var dataDictionary = JSON()
    // session cache, clears when user logout
    fileprivate var localCache: FTCache?

    public static var userCache: FTCache {
        // Will be set-to nil when user logsOut
        if FTUserCache.sharedInstance.localCache == nil {
            FTUserCache.sharedInstance.localCache = FTCache()
        }
        return FTUserCache.sharedInstance.localCache!
    }

    public static func setupSession() {
        //
        _ = NotificationCenter.default.addObserver(forName: .kFTClearSessionCache, object: nil, queue: nil) { _ in
            FTUserCache.clearUserData()
        }
    }

    // MARK: Session Headers
    public static var httpAdditionalHeaders: [String: String]? {
        set {
            let data = newValue
            FTUserCache.setCacheObject(data as AnyObject, forKey: "sessnion.httpAdditionalHeaders", cacheType: .application)
        }
        get {
            return FTUserCache.getCachedObject(forKey: "sessnion.httpAdditionalHeaders") as? [String: String]
        }
    }
}

public extension FTUserCache {

    // httpAdditionalHeaders
    static func defaultSessionHeaders() -> [String: String] {
        var headers = [String: String]()
        FTUserCache.httpAdditionalHeaders?.forEach { key, value in
            headers[key] = value
        }
        return headers
    }
}

public extension FTUserCache {

    @discardableResult
    static func clearUserData() -> Bool {
        FTUserCache.sharedInstance.localCache = nil
        return true
    }

    // Save data to Session object
    @discardableResult
    static func setCacheObject(_ data: AnyObject, key: String, cacheType: FTUserCacheType = .user) -> Bool {
        let key = String(describing: key)
        return FTUserCache.setCacheObject(data, forKey: key, cacheType: cacheType)
    }

    static func getCachedObject(key: String, cacheType: FTUserCacheType = .user) -> Any? {
        let key = String(describing: key)
        return FTUserCache.getCachedObject(forKey: key, cacheType: cacheType)
    }

    @discardableResult
    static func setCacheObject(_ data: AnyObject, forType keyType: AnyClass, cacheType: FTUserCacheType = .user) -> Bool {
        let key = String(describing: keyType)
        return FTUserCache.setCacheObject(data, forKey: key, cacheType: cacheType)
    }

    static func getCachedObject(forType keyType: AnyClass, cacheType: FTUserCacheType = .user) -> Any? {
        let key = String(describing: keyType)
        return FTUserCache.getCachedObject(forKey: key, cacheType: cacheType)
    }
}

// MARK: Saving data into: .user, .keychain, .application
private extension FTUserCache {

    @discardableResult
    static func setCacheObject<T>(_ data: AnyObject?, forKey keyType: T, cacheType: FTUserCacheType = .user) -> Bool where T: Hashable {

        let key: String = (keyType as? String) ?? String(describing: keyType)

        // USER SESSION LEVEL
        if cacheType == .user {
            FTUserCache.userCache.setCacheObject(data, forKey: key)
            return true
        }
            // KeyChain LEVEL
        else if cacheType == .keychain {
            // Save data if avaialble
            if let data = data as? Data {
                return FTKeychainWrapper.standard.set(data, forKey: key, withAccessibility: .whenUnlocked)
            }
            // else Delete old value
            return FTKeychainWrapper.standard.removeObject(forKey: key, withAccessibility: .whenUnlocked)
        }
            // APPILCATION LEVEL
        else {

            let key = String(describing: keyType)
            FTUserCache.sharedInstance.dataDictionary[key] = data
        }

        return true
    }

    // Check-in .user, .keychain, .application
    static func getCachedObject<T>(forKey keyType: T, cacheType: FTUserCacheType = .user) -> Any? where T: Hashable {

        let key: String = (keyType as? String) ?? String(describing: keyType)

        // USER SESSION LEVEL
        if cacheType == .user, let data = FTUserCache.userCache.getCachedObject(forKey: key) {
            return data
        }
            // KeyChain LEVEL
        else if cacheType == .keychain {
            if let data = FTKeychainWrapper.standard.data(forKey: key, withAccessibility: .whenUnlocked) {
                return data
            }
        }
            // APPILCATION LEVEL
        else {
            if let data = FTUserCache.sharedInstance.dataDictionary[key] {
                return data
            }
        }

        // USER SESSION LEVEL
        if let data = FTUserCache.userCache.getCachedObject(forKey: key) {
            return data
        }
            // KeyChain
        else if let data = FTKeychainWrapper.standard.data(forKey: key, withAccessibility: .whenUnlocked) {
            return data
        }

        return nil
    }
}
