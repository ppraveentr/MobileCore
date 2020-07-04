//
//  Logger.swift
//  MobileCoreUtility
//
//  Created by Praveen Prabhakar on 30/09/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

public func ftLog(_ arg: Any ...) {
    if Logger.enableConsoleLogging {
        print(arg)
    }
}

open class Logger {
    public static var enableConsoleLogging = false
}
