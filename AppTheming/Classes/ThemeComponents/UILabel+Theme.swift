//
//  UILabel+Theme.swift
//  CoreUIExtensions
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

// Propery variable to store theme's value.
public protocol LabelThemeProperyProtocol: ThemeProtocol {
    var islinkDetectionEnabled: Bool { get set }
    var isLinkUnderLineEnabled: Bool { get set }
}

extension UILabel: ThemeProtocol {
    // If view is disabled, check for ".disabledStyle" style
    public func getThemeSubType() -> String? {
        self.isEnabled ? nil : ThemeStyle.disabledStyle
    }
    
    // Force update theme attibute
    public func updateTheme(_ theme: ThemeModel) {
        for (kind, value) in theme {
            switch kind {
            case ThemeKey.isLinkUnderlineEnabled.rawValue:
                (self as? LabelThemeProperyProtocol)?.isLinkUnderLineEnabled = value as? Bool ?? false
            case ThemeKey.isLinkDetectionEnabled.rawValue:
                (self as? LabelThemeProperyProtocol)?.islinkDetectionEnabled = value as? Bool ?? false
            case ThemeKey.textfont.rawValue:
                if let font = getFont(value as? String) {
                    self.font = font
                }
            case ThemeKey.textcolor.rawValue:
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
