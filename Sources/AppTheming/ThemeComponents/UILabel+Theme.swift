//
//  UILabel+Theme.swift
//  MobileCore-AppTheming
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

// Propery variable to store theme's value.
public protocol LabelThemeProtocol: ThemeProtocol {
    var islinkDetectionEnabled: Bool { get set }
    var isLinkUnderLineEnabled: Bool { get set }
}

extension UILabel: ThemeProtocol {
    // If view is disabled, check for ".disabledStyle" style
    public func subStyleName() -> ThemeStyle? {
        self.isEnabled ? nil : ThemeStyle.disabledStyle
    }
    
    // Force update theme attibute
    public func updateTheme(_ theme: ThemeModel) {
        for (kind, value) in theme {
            switch kind {
            case ThemeType.Key.isLinkUnderlineEnabled.rawValue:
                (self as? LabelThemeProtocol)?.isLinkUnderLineEnabled = value as? Bool ?? false
            case ThemeType.Key.isLinkDetectionEnabled.rawValue:
                (self as? LabelThemeProtocol)?.islinkDetectionEnabled = value as? Bool ?? false
            case ThemeType.Key.textfont.rawValue:
                if let font = getFont(value as? String) {
                    self.font = font
                }
            case ThemeType.Key.textcolor.rawValue:
                if let color = getColor(value as? String) {
                   self.textColor = color
                }
            default:
                break
            }
        }
        // Send action to superView to update view
        UIApplication.shared.sendAction(#selector(updateVisualThemes), to: nil, from: self, for: nil)
    }
}
