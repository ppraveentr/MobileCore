//
//  UIApplication+Extension.swift
//  MobileCore
//
//  Created by Praveen P on 07/04/20.
//

import Foundation

public extension UIApplication {
    static func keyWindow() -> UIWindow? {
        UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}
