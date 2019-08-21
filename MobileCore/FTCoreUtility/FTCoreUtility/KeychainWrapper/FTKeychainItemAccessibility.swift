//
//  FTKeychainItemAccessibility.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar01 on 20/08/18.
//  Copyright © 2018 Praveen Prabhakar01. All rights reserved.
//

import Foundation

protocol FTKeychainAttrRepresentable {
    var keychainAttrValue: CFString { get }
}

// MARK: - FTKeychainItemAccessibility
public enum FTKeychainItemAccessibility {
    /**
     The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
     
     After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute migrate to a new device when using encrypted backups.
    */
    @available(iOS 4, *)
    case afterFirstUnlock
    
    /**
     The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
     
     After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
     */
    @available(iOS 4, *)
    case afterFirstUnlockThisDeviceOnly
    
    /**
     The data in the keychain item can always be accessed regardless of whether the device is locked.
     
     This is not recommended for application use. Items with this attribute migrate to a new device when using encrypted backups.
     */
    @available(iOS 4, *)
    case always
    
    /**
     The data in the keychain can only be accessed when the device is unlocked. Only available if a passcode is set on the device.
     
     This is recommended for items that only need to be accessible while the application is in the foreground. Items with this attribute never migrate to a new device. After a backup is restored to a new device, these items are missing. No items can be stored in this class on devices without a passcode. Disabling the device passcode causes all items in this class to be deleted.
     */
    @available(iOS 8, *)
    case whenPasscodeSetThisDeviceOnly
    
    /**
     The data in the keychain item can always be accessed regardless of whether the device is locked.
     
     This is not recommended for application use. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
     */
    @available(iOS 4, *)
    case alwaysThisDeviceOnly
    
    /**
     The data in the keychain item can be accessed only while the device is unlocked by the user.
     
     This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute migrate to a new device when using encrypted backups.
     
     This is the default value for keychain items added without explicitly setting an accessibility constant.
     */
    @available(iOS 4, *)
    case whenUnlocked
    
    /**
     The data in the keychain item can be accessed only while the device is unlocked by the user.
     
     This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
     */
    @available(iOS 4, *)
    case whenUnlockedThisDeviceOnly
    
    static func accessibilityForAttributeValue(_ keychainAttrValue: CFString) -> FTKeychainItemAccessibility? {
        for (key, value) in FTKeychainItemAccessibilityLookup {
            if value == keychainAttrValue {
                return key
            }
        }
        
        return nil
    }
}

private let FTKeychainItemAccessibilityLookup: [FTKeychainItemAccessibility:CFString] = {
    let lookup: [FTKeychainItemAccessibility:CFString] = [
        .afterFirstUnlock: kSecAttrAccessibleAfterFirstUnlock,
        .afterFirstUnlockThisDeviceOnly: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
        .always: kSecAttrAccessibleAlways,
        .whenPasscodeSetThisDeviceOnly: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
        .alwaysThisDeviceOnly : kSecAttrAccessibleAlwaysThisDeviceOnly,
        .whenUnlocked: kSecAttrAccessibleWhenUnlocked,
        .whenUnlockedThisDeviceOnly: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    ]

    return lookup
}()

extension FTKeychainItemAccessibility : FTKeychainAttrRepresentable {
    internal var keychainAttrValue: CFString {
        return FTKeychainItemAccessibilityLookup[self]!
    }
}
