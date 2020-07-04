//
//  LabelThemeProperyProtocol.swift
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

public extension LabelThemeProperyProtocol where Self: UILabel {
    // If view is disabled, check for ".disabledStyle" style
    func getThemeSubType() -> String? {
        self.isEnabled ? nil : ThemeStyle.disabledStyle
    }
    
    // Force update theme attibute
    func updateTheme(_ theme: ThemeModel) {
        for (kind, value) in theme {
            switch kind {
            case "isLinkUnderlineEnabled":
                self.isLinkUnderLineEnabled = value as? Bool ?? false
            case "isLinkDetectionEnabled":
                self.islinkDetectionEnabled = value as? Bool ?? false
            case "textfont":
                if let font = getFont(value as? String) {
                    self.font = font
                }
            case "textcolor":
                if let color = getColor(value as? String) {
                   self.textColor = color
                }
            default:
                break
            }
        }
    }
}
