//
//  MobileCoreUIConfig.swift
//  MobileCore
//
//  Created by Praveen P on 18/10/19.
//

import Foundation

public class MobileCoreUIConfig {
    static let sharedInstance = MobileCoreUIConfig()

    public static func setupMobileCoreUI() {
        Reflection.registerModuleIdentifier(FontPickerView.self)
    }
}
